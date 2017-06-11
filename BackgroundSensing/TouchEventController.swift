//
//  MotionController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 05.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit

class TouchEventController {
    
    var collectedTouchEvents = [TouchEvent]()
    let managedObjectContext = DataManager.shared.context
    
    public func addTouchEvent(x: Double, y: Double, type: String, gridID: Int, isHit: Bool) {
        
        let touchEvent = TouchEvent(context: managedObjectContext)
        
        touchEvent.x = x
        touchEvent.y = y
        touchEvent.eventType = type
        touchEvent.timestamp = NSDate()
        touchEvent.gridID = Int16(gridID)
        touchEvent.hit = isHit
        
        collectedTouchEvents.append(touchEvent)
        
        print("Created new TouchEvent: (x: \(x), y: \(y), timestamp: \(String(describing: touchEvent.timestamp)), gridId: \(gridID), type: \(type), hit: \(isHit)")
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
