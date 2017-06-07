//
//  LoginViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 06.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let networkController = NetworkController.shared
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    // MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if let username = usernameTextField?.text, let password = passwordTextField?.text {
            
            let loginCredentials = LoginCredentials(username: username, password: password)
            
            networkController.login(with: loginCredentials) { data, error in
                if let token = data?["token"], let userId = data?["user_id"] {
                    UserDefaults.standard.setValue(token, forKey: "auth_token")
                    UserDefaults.standard.setValue(userId, forKey: "user_id")
                    self.performSegue(withIdentifier: "showStartViewController", sender: nil)
                }
            }

        }
    }
    
}
