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
    
    // MARK: - IB Actions

    @IBAction func startTrailButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showSessionView", sender: nil)
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkSessionAndSetButton()
    }

    // MARK: - Helper
    
    fileprivate func checkSessionAndSetButton() {
        self.startTrailButton.isEnabled = false
        let _ = networkController.checkSessionExists()
            .then { data -> () in
                if let exists: Bool = data["exists"] as? Bool {
                    print("Checked Session for today, response: \(exists)")
                    self.startTrailButton.isEnabled = !exists
                }
            }.catch { error in
                // TODO: display error
                print(error)
            }
    }
}
