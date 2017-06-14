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

    case index      = "INDEX"
    case thumb      = "THUMB"

    static let allValues = [index, thumb]
}

public enum Mood: String {
    
    case one        = "mood-1"
    case two        = "mood-2"
    case three      = "mood-3"
    case four       = "mood-4"
    case five       = "mood-5"
    
    static let allValues = [one, two, three, four, five]
}

struct SessionInformation: JSONSerializable {
    var date: Date
    var userId: Int
    var bodyPosture: BodyPosture
    var typingModality: TypingModality
}
