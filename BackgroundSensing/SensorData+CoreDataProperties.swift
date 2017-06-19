//
//  SensorData+CoreDataProperties.swift
//  
//
//  Created by Emanuel Schmitt on 04.06.17.
//
//

import Foundation
import CoreData
import UIKit


extension SensorData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SensorData> {
        return NSFetchRequest<SensorData>(entityName: "SensorData")
    }

    @NSManaged public var timestamp: NSDate?
    @NSManaged public var type: String?
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var z: Double
    @NSManaged public var user: Int16


    public func toJSONDictionary() -> [String: Any]{
        var sensorDict = [String: Any]()
        
        if let timestamp = self.timestamp as Date? {
            sensorDict["timestamp"] = timestamp.toISOString()
        }
        
        sensorDict["x"] = self.x
        sensorDict["y"] = self.y
        sensorDict["z"] = self.z
        sensorDict["type"] = self.type
        
        sensorDict["device_UDID"] = UIDevice.current.identifierForVendor!.uuidString
        sensorDict["user"] = self.user
        
        return sensorDict
    }
}
