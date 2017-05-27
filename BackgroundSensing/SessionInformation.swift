//
//  SessionInformation.swift
//  BackgroundSensing
//
//  Created by Lukas Würzburger on 5/27/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import Foundation

public enum BodyPosture: String {

    case standing   = "STANDING"
    case sitting    = "SITTING"
    case lying      = "LYING"

    static let allValues = [standing, sitting, lying]
}

public enum TypingModality: String {

    case left       = "LEFT"
    case right      = "RIGHT"

    static let allValues = [left, right]
}

struct SessionInformation: JSONSerializable {

    var bodyPosture: BodyPosture
    var typingModality: TypingModality
}
