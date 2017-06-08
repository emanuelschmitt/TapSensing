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

    
    // MARK: - Actions
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        let sensorDataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SensorData")
        
        do {
            let fetchedSensorData = try managedObjectContext.fetch(sensorDataFetch) as! [SensorData]
            
            networkController.sendSensorData(sensorData: fetchedSensorData) { data, error in
                print(data ?? nil)
            }
            
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
}
