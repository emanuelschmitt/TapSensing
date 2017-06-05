//
//  TouchEvent+CoreDataProperties.swift
//  
//
//  Created by Emanuel Schmitt on 05.06.17.
//
//

import Foundation
import CoreData


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

}
