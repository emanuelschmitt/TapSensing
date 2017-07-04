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
    @NSManaged public var gridShape: String
    
    public func toJSONDictionary() -> [String: Any]{
        var dict = [String: Any]()
        
        if let timestamp = self.timestamp as Date? {
            dict["timestamp"] = timestamp.toISOString()
        }

        dict["x"] = self.x
        dict["y"] = self.y
        dict["grid_id"] = self.gridID
        dict["type"] = self.eventType
        dict["user"] = self.user
        dict["is_hit"] = self.hit
        dict["session_code"] = self.sessionCode
        dict["grid_shape"] = self.gridShape
        
        return dict
    }

}
