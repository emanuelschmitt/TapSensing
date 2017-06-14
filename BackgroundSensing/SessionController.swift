//
//  SessionController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 12.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import Foundation

class SessionControlller {
    
    // MARK: - Variables
    let managedObjectContext = DataManager.shared.context
    
    var session: Session
    
    
    // MARK: - Initializers
    init(){
        session = Session(context: managedObjectContext)
        session.user = Int16(AuthenticationService.shared.userId!)
        session.date = NSDate()
    }

    // MARK: - Helpers
    func persist(){
        DataManager.shared.saveContext()
    }
}
