//
//  NetworkController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 04.05.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//
import Foundation

let BASE_URL: String = "http://130.149.222.214/api/v1/"

private enum requestType {
    case GET, POST
}

private enum endpointURL: String {
    case login = "login/"
}

class NetworkController {
    static let shared = NetworkController()
    
    // MARK: - Helpers
    
    private func buildRequest(requestType: requestType, url: String, data: Data?) -> URLRequest {
        
        var request = URLRequest(url: URL(string: url)!)
        
        // set Json Headers
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        // set Authetication Headers
        if let token = self.getAuthToken() {
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
    
    private func performRequest(request: URLRequest, completionHandler: @escaping ([String: Any]?, Error?) -> ()){
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // networking Error
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            // response non 200
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode > 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            // deserialize Response
            let responseString = String(data: data, encoding: .utf8)
            let reponseDict = self.convertToDictionary(text: responseString!)

            completionHandler(reponseDict, error)
        }
        task.resume()
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func getAuthToken() -> String? {
        if let token = UserDefaults.standard.value(forKey: "auth_token") {
            return token as? String
        }
        else {
            return nil
        }
    }
    
    // MARK: - Endpoints
    
    public func login(with credentials: LoginCredentials, completionHandler: @escaping ([String: Any]?, Error?) -> ()) {
        let url = BASE_URL + endpointURL.login.rawValue
        
        let request = buildRequest(
            requestType: .POST,
            url: url,
            data: credentials.toJSON()
        )

        performRequest(request: request, completionHandler: completionHandler)
    }
}
