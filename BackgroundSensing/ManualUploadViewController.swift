//
//  ViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 6/22/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit

class ManualUploadViewController: UIViewController {

    let uploadController = UploadController()
    
    // MARK: -- Outlets
    
    @IBOutlet weak var sessionsRemainingLabel: UILabel!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    // MARK: -- Actions
    
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        uploadSessions()
    }
    
    // MARK: -- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewController()
    }
    
    // MARK: -- Helpers
    
    fileprivate func setupViewController() {
        activityIndicator.isHidden = true
        
        let sessionCount = uploadController.getSessionCount()
        sessionsRemainingLabel.text = "\(sessionCount) Session"
        
        let buttonActive = sessionCount > 0
        setButtonState(buttonActive)
    }
    
    fileprivate func uploadSessions() {

        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        uploadController.uploadSessions().then {_ in
            self.setupViewController()
        }.catch { error in
            self.handleUploadError(error: error as NSError)
        }.always {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    fileprivate func handleUploadError(error: NSError) {
        let alertController = UIAlertController(title: "Server Error", message: "Could not upload sessions. Code: \(error.code)", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func setButtonState(_ active: Bool){
        if (active) {
            uploadButton.backgroundColor = UIColor(red: 0.251, green: 0.588, blue: 0.969, alpha: 1.00)
            uploadButton.isEnabled = true
        } else {
            uploadButton.backgroundColor = UIColor.gray
            uploadButton.isEnabled = false
        }
    }

}
