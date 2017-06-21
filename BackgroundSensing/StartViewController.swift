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
    
    fileprivate func setLabelText(_ trailToBeDone: Bool){
        let localizationKey = trailToBeDone ? "startviewcontroller-info-label-tail-to-be-done" : "startviewcontroller-info-label-tail-done"
        self.instructionLabel.text = NSLocalizedString(localizationKey, comment: "")
    }
    
    fileprivate func setButtonState(_ trailToBeDone: Bool){
        if (trailToBeDone) {
            startTrailButton.backgroundColor = UIColor(red: 0.251, green: 0.588, blue: 0.969, alpha: 1.00)
            startTrailButton.isEnabled = true
        } else {
            startTrailButton.backgroundColor = UIColor.gray
            startTrailButton.isEnabled = false
        }
    }
    
    fileprivate func checkSessionAndSetButtonAndLabel() {
        self.setButtonState(false)
        self.setLabelText(false)

        let _ = networkController.checkSessionExists()
            .then { data -> () in
                if let exists: Bool = data["exists"] as? Bool {
                    print("Checked Session for today, response: \(exists)")
                    
                    self.setButtonState(!exists)
                    self.setLabelText(!exists)
                }
            }.catch { error in
                // TODO: display error
                print(error)
            }
    }
}
