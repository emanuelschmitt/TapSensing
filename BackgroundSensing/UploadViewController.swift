//
//  UploadViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 05.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit
import CoreData
import Hydra

class UploadViewController: UIViewController{
    
    let managedObjectContext = DataManager.shared.context
    let networkController = NetworkController.shared
    let uploadController = UploadController()
    
    // MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.activityLabel.text = "Upload Session Data..."
        startUpload()
    }
    
    // MARK: - Actions
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        startUpload()
    }

    fileprivate func startUpload(){
        self.activityIndicator.startAnimating()

        self.activityLabel.text = "Preparing upload..."
        
        uploadController.uploadSessions().then {_ in
                // TODO:
            }.catch { error in
                self.handleUploadError(error: error as NSError)
            }.always {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.presentNextPage()
        }
    }
    
    fileprivate func handleUploadError(error: NSError) {
        let alertController = UIAlertController(title: "Server Error", message: "Could not upload sessions. Code: \(error.code)", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func presentNextPage() {
        if let parent = self.parent as? SessionViewController {
            parent.goToNextPage()
        }
    }
}
