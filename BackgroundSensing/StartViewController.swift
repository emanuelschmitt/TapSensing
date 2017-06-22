//
//  StartViewController.swift
//  BackgroundSensing
//
//  Created by Lukas Würzburger on 5/27/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit
import PromiseKit

class StartViewController: UIViewController {
    
    let networkController = NetworkController.shared
    var trialToBePerformed = false
    
    // MARK: - IB Outlet

    @IBOutlet weak var startTrailButton: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!

    // MARK: - IB Actions

    @IBAction func startTrailButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showSessionView", sender: nil)
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        checkSessionAndSetButtonAndLabel()
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkSessionAndSetButtonAndLabel()
    }

    // MARK: - Helper

    fileprivate func setLabelText(){
        let localizationKey = self.trialToBePerformed ?
            "startviewcontroller-info-label-tail-to-be-done" :
            "startviewcontroller-info-label-tail-done"
        
        self.instructionLabel.text = NSLocalizedString(localizationKey, comment: "")
    }
    
    fileprivate func setButtonState(){
        if (self.trialToBePerformed) {
            startTrailButton.backgroundColor = UIColor(red: 0.251, green: 0.588, blue: 0.969, alpha: 1.00)
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
                if let exists: Bool = data["exists"] as? Bool {
                    print("Checked Session for today, response: \(exists)")
                    self.trialToBePerformed = !exists
                }
            }
            .catch { error in
                self.handleSessionCheckError(error: error as NSError)
                self.trialToBePerformed = false
            }
            .always {
                self.setButtonState()
                self.setLabelText()
            }
    }
    
    fileprivate func handleSessionCheckError(error: NSError) {
        let alertController = UIAlertController(title: "Server Error", message: "Could not fetch trial state from server. Code: \(error.code)", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
