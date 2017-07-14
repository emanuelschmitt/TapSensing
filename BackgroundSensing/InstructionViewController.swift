//
//  InstructionViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 7/13/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        
        if let parent = self.parent as? SessionViewController {
            parent.goToNextPage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.bideawee.org/")
        if let unwrappedURL = url {
            
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if error == nil {
                    
                    self.webView.loadRequest(request)
                    
                } else {
                    
                    print("ERROR: \(String(describing: error))")
                    
                }
                
            }
            
            task.resume()

        }
    }

}
