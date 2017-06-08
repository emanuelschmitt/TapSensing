//
//  MotionController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 05.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import CoreMotion
import CoreData
import UIKit

let UPDATE_INTERVAL = 0.01

public enum SensorType: String {
    case Gyroscope = "GYROSCOPE"
    case Acceleromteter = "ACCELEROMETER"
}

class MotionController {
    
    let motionManager = CMMotionManager()
    var collectedSensorData = [SensorData]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    public func startSensorRecording() {
        motionManager.gyroUpdateInterval = UPDATE_INTERVAL
        motionManager.accelerometerUpdateInterval = UPDATE_INTERVAL
        
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        
        motionManager.startAccelerometerUpdates(to: .main) {
            (data: CMAccelerometerData?, error: Error?) in
            if let acceleration = data?.acceleration {
                self.pushAccerometerData(acceleration: acceleration)
            }
        }
        
        motionManager.startGyroUpdates(to: .main) {
            (data: CMGyroData?, error: Error?) in
            if let rotationRate = data?.rotationRate {
                self.pushGyroscopeData(rotationRate: rotationRate)
            }
        }
    }
    
    public func stopSensorRecordings() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }
    
    public func persistSensorRecordings() {
        print("Persisting Sensor Recordings...")
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    private func pushGyroscopeData(rotationRate: CMRotationRate){
        let sd  = SensorData(context: managedObjectContext)
        
        sd.type = SensorType.Gyroscope.rawValue
        sd.x = rotationRate.x
        sd.y = rotationRate.y
        sd.z = rotationRate.z
        sd.timestamp = NSDate()
        
        self.collectedSensorData.append(sd)
        print("collectedDataCount: \(self.collectedSensorData.count)")
    }
    
    private func pushAccerometerData(acceleration: CMAcceleration){
        let sd  = SensorData(context: managedObjectContext)
        
        sd.type = SensorType.Acceleromteter.rawValue
        sd.x = acceleration.x
        sd.y = acceleration.y
        sd.z = acceleration.z
        sd.timestamp = NSDate()
        
        self.collectedSensorData.append(sd)
    }

    deinit{
        stopSensorRecordings()
        collectedSensorData.removeAll()
    }
}
