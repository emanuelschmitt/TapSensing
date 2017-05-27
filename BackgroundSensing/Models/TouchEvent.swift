//
//  TouchEvent.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 23.05.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import Foundation

public struct TouchEvent: JSONSerializable {
    public var x: Double
    public var y: Double
    public var timestamp: String
    public var eventType: String
    
    public init (x: Double, y: Double, timestamp: String, eventType: String) {
        self.x = x
        self.y = y
        self.timestamp = timestamp
        self.eventType = eventType
    }
}
