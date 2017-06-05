//
//  User+CoreDataProperties.swift
//  
//
//  Created by Emanuel Schmitt on 04.06.17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var authToken: String?
    @NSManaged public var id: Int16

}
