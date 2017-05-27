//
//  NetworkController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 04.05.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import Alamofire

class NetworkController {
    static let shared = NetworkController()
    
    private let BASE_URL = "http://52.29.70.27:8000"
    
    private var queue = Queue<Data>()
    
    func enqueue(data: Data){
        print("Enqueued element. QueueSize: \(self.queue.count)")
        self.queue.enqueue(data)
    }
    
    func performNext(){
        if let data = self.queue.dequeue() {
            print("Dequeued element. QueueSize: \(self.queue.count)")
            self.doRequest(data: data)
            self.queue.enqueue(data)
            self.performNext()
        }
    }
    
    func doRequest(data: Data){
        var request = URLRequest(url: URL(string: BASE_URL + "/gyro")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = data
        print(String(data: data, encoding: String.Encoding.utf8))
        
        Alamofire
            .request(request)
            .responseJSON { response in
                switch response.result {
                case .failure(let error):
                    print(error)
                case .success(let responseObject):
                    print(responseObject)
                }
        }
    }
}
