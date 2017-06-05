//
//  SensorData+CoreDataProperties.swift
//  
//
//  Created by Emanuel Schmitt on 04.06.17.
//
//

import Foundation
import CoreData


extension SensorData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SensorData> {
        return NSFetchRequest<SensorData>(entityName: "SensorData")
    }

    @NSManaged public var timestamp: NSDate?
    @NSManaged public var type: String?
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var z: Double

}
