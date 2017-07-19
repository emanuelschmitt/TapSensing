//
//  UploadController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 6/22/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import CoreData
import Hydra


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
        
        let promises: [Promise<[[String: Any]]>] = [sessionPromise, sensorDataPromise, touchEventPromise]
        
        return Promise<()>(in: .main, {resolve, reject in
        
            return all(promises)
                .then { data -> () in
                    
                    let sensor = data[1]
                    let touchEvent = data[2]
                    
                    // check if all sensor data was recieved by backend
                    let allTouchesRecieved = self.checkCountsInResponseDictionary(dictionary: touchEvent, count:touchEvents.count)
                    let allSensorDataRecieved = self.checkCountsInResponseDictionary(dictionary: sensor, count: sensorData.count)
                    
                    if (allTouchesRecieved && allSensorDataRecieved) {
                        self.deleteRecords(session: session, sensorData: sensorData, touchEvents: touchEvents)
                    }
                    
                    resolve()
                }
                .catch { error in
                    print(error)
                    reject(error)
            }

            
        })
    }
    
    fileprivate func deleteRecords(session: Session, sensorData: [SensorData], touchEvents: [TouchEvent]) {
        self.managedObjectContext.delete(session)
        let _ = sensorData.map { self.managedObjectContext.delete($0) }
        let _ = touchEvents.map { self.managedObjectContext.delete($0) }
        
        DataManager.shared.saveContext()
    }
    
    fileprivate func checkCountsInResponseDictionary(dictionary: [[String: Any]], count: Int) -> Bool {
        let flattenedDict = dictionary.flatMap {$0}
        let countValues = flattenedDict.map {(key, value) in value as! Int}
        let finalCount = countValues.reduce(0, +)
        return finalCount == count
    }
    
    public func uploadSessions() -> Promise<Array<()>>{
        let sessions = self.fetchSessions()
        let sessionPromises = sessions.map {session -> Promise<Void> in self.upload(session: session)}
        return all(sessionPromises)
    }

    
}
