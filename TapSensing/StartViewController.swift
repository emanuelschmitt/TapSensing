//
//  StartViewController.swift
//  BackgroundSensing
//
//  Created by Lukas Würzburger on 5/27/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit

//Backend States
//LAB_MODE = 'LAB_MODE'
//NOT_DONE_TODAY = 'NOT_DONE_TODAY'
//DONE_TODAY = 'DONE_TODAY'
//COMPLETED = 'COMPLETED'

public enum SessionState: String {
    case labMode      = "LAB_MODE"
    case notDoneToday = "NOT_DONE_TODAY"
    case doneToday = "DONE_TODAY"
    case completed = "COMPLETED"
}

class StartViewController: UIViewController {
    
    
    // MARK: - Variables
    
    let networkController = NetworkController.shared
    
    // Set the inital state to be not done
    // until it fetches the status from the server
    var sessionState: SessionState = .notDoneToday
    
    
    // MARK: - IB Outlet

    @IBOutlet weak var startTrailButton: UIButton!
    
    @IBOutlet weak var instructionLabel: UILabel!

    @IBOutlet weak var instructionInfoLabel: UILabel!
    
    
    
    // MARK: - IB Actions

    @IBAction func startTrailButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showSessionView", sender: nil)
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        checkSessionAndSetButtonAndLabel()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        AuthenticationService.shared.deauthenticate()
        let _ = checkAuthenticationStatus()
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isAuthenticated = checkAuthenticationStatus()
        if (isAuthenticated) { checkSessionAndSetButtonAndLabel() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let _ = checkAuthenticationStatus()
    }

    // MARK: - Helper
    
    fileprivate func checkAuthenticationStatus() -> Bool {
        let isAuthenticated = AuthenticationService.shared.isAuthenticated()
        if (!isAuthenticated) {
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }
        return isAuthenticated
    }

    fileprivate func setLabelText(){
        
        var headerKey: String = "";
        var infoKey: String = "";
        
        switch self.sessionState {
        case .labMode:
            headerKey = "startviewcontroller-info-header-lab-mode"
            infoKey = "startviewcontroller-info-text-lab-mode"
            
        case .doneToday:
            headerKey = "startviewcontroller-info-header-done-today"
            infoKey = "startviewcontroller-info-text-done-today"
            
        case .notDoneToday:
            headerKey = "startviewcontroller-info-header-not-done-today"
            infoKey = "startviewcontroller-info-text-not-done-today"
            
        case .completed:
            headerKey = "startviewcontroller-info-header-completed"
            infoKey = "startviewcontroller-info-text-completed"
        }

        self.instructionLabel.text = NSLocalizedString(headerKey, comment: "")
        self.instructionInfoLabel.text = NSLocalizedString(infoKey, comment: "")
    }
    
    fileprivate func setButtonState(){
        if (self.sessionState == .labMode || self.sessionState == .notDoneToday) {
            startTrailButton.backgroundColor = UIColor(red: 0.341, green: 0.706, blue: 0.608, alpha: 1.00)
            startTrailButton.isEnabled = true
        } else {
            startTrailButton.backgroundColor = UIColor.gray
            startTrailButton.isEnabled = false
        }
    }
    
    fileprivate func checkSessionAndSetButtonAndLabel() {
        self.setButtonState()
        self.setLabelText()

        let _ = networkController.checkSessionExists()
            .then { data -> () in
                if let state: String = data["state"] as? String {
                    print("Checked Session for today, response: \(state)")
                    self.sessionState = SessionState(rawValue: state)!
                }
            }
            .catch { error in
                self.handleSessionCheckError(error: error as NSError)
            }
            .always {
                DispatchQueue.main.async() {
                    self.setButtonState()
                    self.setLabelText()
                }
            }
    }
    
    fileprivate func handleSessionCheckError(error: NSError) {
        let alertController = UIAlertController(title: "Server Error", message: "Could not fetch trial state from server. Code: \(error.code)", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
