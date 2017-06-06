//
//  NetworkController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 04.05.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import Alamofire

fileprivate let BASE_URL = "http://130.149.222.214/api/v1/"

private enum requestType {
    case GET, POST
}

class NetworkController {
    static let shared = NetworkController()
    
    private func buildRequest(requestType: requestType, url: String, data: Data?) -> URLRequest {
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
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
    
    private func performRequest(request: URLRequest, completionHandler: @escaping ([String: Any]?) -> ()){
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
            
            completionHandler(reponseDict!)
        }
        task.resume()
    }
    
    public func login(with credentials: LoginCredentials) {
        let endPointUrlString = BASE_URL + "login/"
        let request = buildRequest(requestType: .POST, url: endPointUrlString, data: credentials.toJSON())
        
        performRequest(request: request) { data in
            print(data)
        }
        
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
}
