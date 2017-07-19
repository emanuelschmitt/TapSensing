//
//  AppDelegate.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 18/04/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Variables

    var window: UIWindow?

    // MARK: - Application Delegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = initialViewController()
        
        registerForPushNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Token recieved: token")
        UserDefaults.standard.setValue(token, forKey: "device_token")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    // MARK: - Helpers
    
    fileprivate func initialViewController() -> UIViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController!
        viewController = mainStoryboard.instantiateInitialViewController()
        return viewController
    }
    
    // MARK: - Helpers Push Notifications
    fileprivate func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    fileprivate func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}

