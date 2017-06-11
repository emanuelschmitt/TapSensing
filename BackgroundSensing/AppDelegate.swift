//
//  AppDelegate.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 18/04/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Variables

    var window: UIWindow?

    // MARK: - Application Delegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = initialViewController()
        return true
    }
    
    // MARK: - Helpers
    
    fileprivate func initialViewController() -> UIViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController!
        if (AuthenticationService.shared.isAuthenticated()) {
            viewController = mainStoryboard.instantiateInitialViewController()
        } else {
            viewController = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController")
        }
        return viewController
    }
}

