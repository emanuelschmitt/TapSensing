//
//  QuestionIntroViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 7/13/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit

class QuestionIntroViewController: UIViewController {

    @IBAction func dismissButtonPressed(_ sender: Any) {
        
        if let parent = self.parent as? SessionViewController {
            parent.goToNextPage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
