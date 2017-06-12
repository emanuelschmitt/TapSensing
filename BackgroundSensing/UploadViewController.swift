//
//  UploadViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 05.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit
import CoreData
import PromiseKit

class UploadViewController: UIViewController{
    
    let managedObjectContext = DataManager.shared.context
    let networkController = NetworkController.shared

    var sensorData: [SensorData] = [SensorData]()
    var touchEvents: [TouchEvent] = [TouchEvent]()
    var sessions: [Session] = [Session]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Actions
    
    @IBAction func uploadButtonPressed(_ sender: Any) {

        self.activityIndicator.startAnimating()
        
        do {
            
            let sensorDataFetch: NSFetchRequest<SensorData> = SensorData.fetchRequest()
            let touchEventFetch: NSFetchRequest<TouchEvent> = TouchEvent.fetchRequest()
            let sessionFetch: NSFetchRequest<Session> = Session.fetchRequest()
            
            self.sensorData = try managedObjectContext.fetch(sensorDataFetch) 
            self.touchEvents = try managedObjectContext.fetch(touchEventFetch)
            self.sessions = try managedObjectContext.fetch(sessionFetch)
            
            print("Fetched \(self.sensorData.count) SensorData Objects.")
            print("Fetched \(self.touchEvents.count) TouchEvent Objects.")
            
            when(fulfilled:
                networkController.send(session: self.sessions.first!),
                networkController.send(touchEvents: self.touchEvents),
                networkController.send(sensorData: self.sensorData)
            )
            .then { (sessionResponse, touchResponse, sensorResponse) -> () in
                print(sessionResponse)
                // check if all sensor data was recieved by backend
                let allTouchesRecieved = self.checkCountsInResponseDictionary(dictionary: touchResponse, count: self.touchEvents.count)
                let allSensorDataRecieved = self.checkCountsInResponseDictionary(dictionary: sensorResponse, count: self.sensorData.count)
                
                if (allTouchesRecieved && allSensorDataRecieved) {
                    self.deleteRecords()
                }
            }.catch { error in
                print(error)
            }.always {

                self.activityIndicator.stopAnimating()
                if let parent = self.parent as? SessionViewController{
                    parent.goToNextPage()
                }
            }

        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    fileprivate func deleteRecords() {
        let _ = self.sensorData.map { managedObjectContext.delete($0) }
        let _ = self.touchEvents.map { managedObjectContext.delete($0) }
        
        DataManager.shared.saveContext()
        
        self.sensorData.removeAll()
        self.touchEvents.removeAll()
    }

    fileprivate func checkCountsInResponseDictionary(dictionary: [[String: Any]], count: Int) -> Bool {
        let flattenedDict = dictionary.flatMap {$0}
        let countValues = flattenedDict.map {(key, value) in value as! Int}
        let finalCount = countValues.reduce(0, +)
        return finalCount == count
    }
}
