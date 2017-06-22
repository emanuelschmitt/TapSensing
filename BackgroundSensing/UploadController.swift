//
//  UploadController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 6/22/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import CoreData
import PromiseKit

class UploadController {
    
    let managedObjectContext = DataManager.shared.context
    let networkController = NetworkController.shared

    public func getSessionCount() -> Int {
        let sessions = self.fetchSessions()
        return sessions.count
    }
    
    fileprivate func fetchSessions() -> [Session] {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        var sessions: [Session] = [Session]()
        
        do {
            sessions = try managedObjectContext.fetch(fetchRequest)
        } catch {
            // TODO: handle Error ALERT
        }
        
        print("Fetched \(sessions.count) Session")
        
        return sessions
    }
    
    fileprivate func fetchSensorDataFor(sessionCode: String) -> [SensorData] {
        let fetchRequest: NSFetchRequest<SensorData> = SensorData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sessionCode == %@", sessionCode)
        var sensorData: [SensorData] = [SensorData]()
        
        do {
            sensorData = try managedObjectContext.fetch(fetchRequest)
        } catch {
            // TODO: handle Error ALERT
        }
        
        print("Fetched \(sensorData.count) SensorData")
        
        return sensorData
    }
    
    fileprivate func fetchTouchEventsFor(sessionCode: String) -> [TouchEvent] {
        let fetchRequest: NSFetchRequest<TouchEvent> = TouchEvent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sessionCode == %@", sessionCode)
        var touchEvents: [TouchEvent] = [TouchEvent]()
        
        do {
            touchEvents = try managedObjectContext.fetch(fetchRequest)
        } catch {
            // TODO: handle Error ALERT
        }
        
        print("Fetched \(touchEvents.count) TouchEvents")
        return touchEvents
    }
    
    fileprivate func upload(session: Session) -> Promise<()> {
        let touchEvents = fetchTouchEventsFor(sessionCode: session.sessionCode)
        let sensorData = fetchSensorDataFor(sessionCode: session.sessionCode)
        
        let sessionPromise = self.networkController.send(session: session)
        let sensorDataPromise = self.networkController.send(sensorData: sensorData)
        let touchEventPromise = self.networkController.send(touchEvents: touchEvents)
        
        return Promise<()> {fulfill, reject in
            when(fulfilled: sessionPromise, sensorDataPromise, touchEventPromise)
                .then { (sessionResponse, sensorResponse, touchResponse) -> () in
                    print(sessionResponse)
                    
                    // check if all sensor data was recieved by backend
                    let allTouchesRecieved = self.checkCountsInResponseDictionary(dictionary: touchResponse, count:touchEvents.count)
                    let allSensorDataRecieved = self.checkCountsInResponseDictionary(dictionary: sensorResponse, count: sensorData.count)
                    
                    if (allTouchesRecieved && allSensorDataRecieved) {
                        self.deleteRecords(session: session, sensorData: sensorData, touchEvents: touchEvents)
                    }
                    
                    fulfill()
                }
                .catch { error in
                    print(error)
                    reject(error)
            }
        }
    }
    
    fileprivate func deleteRecords(session: Session, sensorData: [SensorData], touchEvents: [TouchEvent]) {
        managedObjectContext.delete(session)
        let _ = sensorData.map { managedObjectContext.delete($0) }
        let _ = touchEvents.map { managedObjectContext.delete($0) }
        
        DataManager.shared.saveContext()
    }
    
    fileprivate func checkCountsInResponseDictionary(dictionary: [[String: Any]], count: Int) -> Bool {
        let flattenedDict = dictionary.flatMap {$0}
        let countValues = flattenedDict.map {(key, value) in value as! Int}
        let finalCount = countValues.reduce(0, +)
        return finalCount == count
    }
    
    public func uploadSessions() -> Promise<()>{
        let sessions = fetchSessions()
        let sessionPromises = sessions.map {session -> Promise<()> in self.upload(session: session)}
        return when(fulfilled: sessionPromises)
    }

    
}
