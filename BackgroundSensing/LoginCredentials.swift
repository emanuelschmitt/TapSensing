//
//  LoginCredentials.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 05.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

public struct LoginCredentials: JSONSerializable {
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
