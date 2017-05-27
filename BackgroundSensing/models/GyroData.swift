//
//  TouchEvent.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 23.05.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

public struct GyroData: JSONSerializable {
    public var x: Double
    public var y: Double
    public var z: Double
    public var timestamp: String
    
    public init(x: Double, y: Double, z: Double, timestamp: String) {
        self.x = x
        self.y = y
        self.z = z
        self.timestamp = timestamp;
    }
}
