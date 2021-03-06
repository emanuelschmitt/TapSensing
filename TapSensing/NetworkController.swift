//
//  NetworkController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 04.05.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//
import Foundation
import Hydra

let BASE_URL: String = "https://api.tapsensing.de/api/v1/"
let CHUNK_SIZE: Int = 300
let CONCURRENCY: UInt = 3
let RETRY_COUNT: Int = 3

private enum requestType {
    case GET, POST
}

private enum endpointURL: String {
    case login = "login/"
    case sensorData = "sensordata/"
    case touchEvent = "touchevent/"
    case sessionExists = "session/exists/"
    case session = "session/"
    case apnsRegister = "apns/"
    case trialSettings = "trial-settings/"
}

class NetworkController {
    
    static let shared = NetworkController()
    
    let authenticationService = AuthenticationService.shared
    
    
    // MARK: - Helpers
    
    private func buildRequest(requestType: requestType, url: String, data: Data?) -> URLRequest {
        
        var request = URLRequest(url: URL(string: url)!)
        
        // set Headers
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        // set Authetication Header
        if (authenticationService.isAuthenticated()){
            let token = authenticationService.authToken!
            request.setValue("Token " + token, forHTTPHeaderField: "Authorization")
        }
        
        switch requestType{

        case .GET:
            request.httpMethod = "GET"
            break
        
        case .POST:
            request.httpMethod = "POST"
            request.httpBody = data!
            break
        }
        
        return request
    }
    
    private func performRequest(request: URLRequest) -> Promise<[String: Any]>{
        return Promise<[String: Any]>(in: .background, { resolve, reject in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode >= 400 {
                        print(httpResponse)
                        let error = NSError(domain: "NetworkController", code: httpResponse.statusCode, userInfo: nil)
                        reject(error)
                    }
                }
                
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    resolve(json!)
                } else if let error = error {
                    reject(error)
                    
                } else {
                    let error = NSError(domain: "NetworkController", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                    reject(error)
                }
            }
            task.resume()
        }).retry(RETRY_COUNT)
    }
    
    // MARK: - Endpoints
    
    public func login(with credentials: LoginCredentials) -> Promise<[String: Any]> {
        let url = BASE_URL + endpointURL.login.rawValue
        
        let request = buildRequest(
            requestType: .POST,
            url: url,
            data: credentials.toJSON()
        )

        return performRequest(request: request)
    }

    
    public func send(sensorData: [SensorData]) -> Promise<[[String: Any]]>{
    
        let url = BASE_URL + endpointURL.sensorData.rawValue
        
        // Split all SensorData into arrays of CHUNK_SIZE
        let sensorDataChunks = sensorData.splitBy(subSize: CHUNK_SIZE)

        func sendChunk(sensorDataArray: [SensorData]) -> Promise<[String: Any]> {
            let jsonArray = sensorDataArray.map({ return $0.toJSONDictionary() })
            
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray, options: [])
            let request = buildRequest(
                requestType: .POST,
                url: url,
                data: jsonData
            )

            return performRequest(request: request)
        }
        
        // Create promise for each sensor chunk
        let chunkPromises = sensorDataChunks.map({ chunk in return sendChunk(sensorDataArray: chunk) })
    
        // Return promise when fulfilling all promises
        return all(chunkPromises, concurrency: CONCURRENCY)
    }
    
    
    public func send(touchEvents: [TouchEvent]) -> Promise<[[String: Any]]>{
        
        let url = BASE_URL + endpointURL.touchEvent.rawValue

        // Split all SensorData into arrays of CHUNK_SIZE
        let chunks = touchEvents.splitBy(subSize: CHUNK_SIZE)
        
        func sendChunk(arr: [TouchEvent]) -> Promise<[String: Any]> {
            let jsonArray = arr.map({ return $0.toJSONDictionary() })
            
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray, options: [])
            let request = buildRequest(
                requestType: .POST,
                url: url,
                data: jsonData
            )
            
            return performRequest(request: request)
        }
        
        // Create promise for each sensor chunk
        let promises = chunks.map({
            chunk in return sendChunk(arr: chunk)
        })
        
        // Return promise when fulfilling all promises
        return all(promises, concurrency: CONCURRENCY)
    }
    
    public func checkSessionExists() -> Promise<[String: Any]> {
        let url = BASE_URL + endpointURL.sessionExists.rawValue
        let request = buildRequest(requestType: .GET, url: url, data: nil)
        return performRequest(request: request)
    }
    
    public func send(session: Session) -> Promise<[[String: Any]]> {
        let url = BASE_URL + endpointURL.session.rawValue
        let jsonData = try? JSONSerialization.data(withJSONObject: session.toJSONDictionary(), options: [])
        let request = buildRequest(requestType: .POST, url: url, data: jsonData)
        return all([performRequest(request: request)])
    }
    
    public func send(deviceToken: String) -> Promise<[String: Any]> {
        let url = BASE_URL + endpointURL.apnsRegister.rawValue
        let dict: [String:Any] = ["device_token": deviceToken]
        print(dict)
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let request = buildRequest(requestType: .POST, url: url, data: jsonData)
        return performRequest(request: request)
    }
    
    public func fetchTrialSettings() -> Promise<[String: Any]> {
        let url = BASE_URL + endpointURL.trialSettings.rawValue
        let request = buildRequest(requestType: .GET, url: url, data: nil)
        return performRequest(request: request)
    }
}
