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
    @NSManaged public var sessionCode: String


    public func toJSONDictionary() -> [String: Any]{
        var dict = [String: Any]()
        
        if let timestamp = self.timestamp as Date? {
            dict["timestamp"] = timestamp.toISOString()
        }
        
        dict["x"] = self.x
        dict["y"] = self.y
        dict["z"] = self.z
        dict["type"] = self.type
        dict["user"] = self.user
        dict["session_code"] = self.sessionCode

        return dict
    }
}
