//
//  TouchEvent+CoreDataProperties.swift
//  
//
//  Created by Emanuel Schmitt on 05.06.17.
//
//

import Foundation
import CoreData
import UIKit


extension TouchEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TouchEvent> {
        return NSFetchRequest<TouchEvent>(entityName: "TouchEvent")
    }

    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var eventType: String?
    @NSManaged public var gridID: Int16
    @NSManaged public var hit: Bool
    @NSManaged public var user: Int16
    @NSManaged public var sessionCode: String
    
    public func toJSONDictionary() -> [String: Any]{
        var sensorDict = [String: Any]()
        
        if let timestamp = self.timestamp as Date? {
            sensorDict["timestamp"] = timestamp.toISOString()
        }

        sensorDict["x"] = self.x
        sensorDict["y"] = self.y
        sensorDict["grid_id"] = self.gridID
        sensorDict["type"] = self.eventType
        sensorDict["device_UDID"] = UIDevice.current.identifierForVendor!.uuidString
        sensorDict["user"] = self.user
        sensorDict["is_hit"] = self.hit
        sensorDict["session_code"] = self.sessionCode
        
        return sensorDict
    }

}
