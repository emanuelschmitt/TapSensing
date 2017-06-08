//
//  UploadViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 05.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit
import CoreData

class UploadViewController: UIViewController{
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let networkController = NetworkController.shared

    // MARK: - Outlets
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Actions
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        let sensorDataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SensorData")
        
        do {
            let fetchedSensorData = try managedObjectContext.fetch(sensorDataFetch) as! [SensorData]
            
            let _ = networkController.sendSensorData(sensorData: fetchedSensorData).then { data -> () in
                print("success")
            }
            
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
}
