//
//  AuthenticationService.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 07.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//
import Foundation

class AuthenticationService {
    static let shared = AuthenticationService()
    
    var userId: Int? {
        get {
            return self.isAuthenticated() ? UserDefaults.standard.value(forKey: "user_id") as? Int : nil
        }
    }
    
    var authToken: String? {
        get {
            return self.isAuthenticated() ? UserDefaults.standard.value(forKey: "auth_token") as? String : nil
        }
    }
    
    public func authenticate(userId: Int, authToken: String) -> () {
        UserDefaults.standard.setValue(userId, forKey: "user_id")
        UserDefaults.standard.setValue(authToken, forKey: "auth_token")
    }
    
    public func deauthenticate() -> () {
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "auth_token")
    }
    
    public func isAuthenticated() -> Bool {
        // check if NSUserDefaults are set for authtoken and user_id
        let isAuthTokenSet: Bool = UserDefaults.standard.value(forKey: "auth_token") != nil
        let isUserIdSet: Bool = UserDefaults.standard.value(forKey: "user_id") != nil
        
        return isAuthTokenSet && isUserIdSet
    }
}
