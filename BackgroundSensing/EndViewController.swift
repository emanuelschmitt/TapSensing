//
//  EndViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 12.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    @IBAction func dismissButtonPressed(_ sender: Any) {
    
        if let parent = self.parent as? SessionViewController {
            parent.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
