//
//  MotionController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 05.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import CoreData
import UIKit

class TouchEventController {
    
    var collectedTouchEvents = [TouchEvent]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public func addTouchEvent(x: Double, y: Double, type: String, gridID: Int, isHit: Bool) {
        
        let touchEvent = TouchEvent(context: managedObjectContext)
        
        touchEvent.setValue(x, forKey: "x")
        touchEvent.setValue(y, forKey: "y")
        touchEvent.setValue(type, forKey: "eventType")
        touchEvent.setValue(NSDate(), forKey: "timestamp")
        touchEvent.setValue(gridID, forKey: "gridID")
        touchEvent.setValue(isHit, forKey: "hit")
        
        collectedTouchEvents.append(touchEvent)
        
        print("collectedTouchEvents: \(collectedTouchEvents.count)")
    }
    
    public func persistTouchEvents() {
        
        print("Persisting Touch Events...")
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    deinit{
        collectedTouchEvents.removeAll()
    }

}
