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
    public var timestamp: Double
    public var eventType: String
}
