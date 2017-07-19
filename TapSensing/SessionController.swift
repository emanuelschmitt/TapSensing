//
//  SessionController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 12.06.17.
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
    
    case one        = "m1"
    case two        = "m2"
    case three      = "m3"
    case four       = "m4"
    case five       = "m5"
    
    static let allValues = [one, two, three, four, five]
}

public enum Hand: String {
    
    case left      = "HAND_LEFT"
    case right      = "HAND_RIGHT"
    
    static let allValues = [left, right]
}

func generateSessionCode(_ userId: Int,_ date: Date) -> String {
    
    let userIdString = String(userId)
    let dateString = date.toDateCodeString()
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< 10 {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return userIdString + dateString + randomString
}

class SessionControlller {
    
    static let shared = SessionControlller()
    
    // MARK: - Variables
    
    let managedObjectContext = DataManager.shared.context
    
    var sessionCode: String
    var bodyPosture: String?
    var typingModality: String?
    var mood: String?
    var hand: String?
    
    init() {
        self.sessionCode = generateSessionCode(AuthenticationService.shared.userId!, Date())
    }
    
    func reinitializeSession() {
        sessionCode = generateSessionCode(AuthenticationService.shared.userId!, Date())
        bodyPosture = nil
        typingModality = nil
        mood = nil
    }
    
    // MARK: - Helpers
    
    func persistSession(){
        guard let bodyPosture = self.bodyPosture,
            let typingModality = self.typingModality,
            let mood = self.mood,
            let hand = self.hand else {
            print("Fields in Sessioncontroller are not set.")
            return;
        }
        
        let session = Session(context: managedObjectContext)
        
        session.bodyPosture = bodyPosture
        session.typingModality = typingModality
        session.hand = hand
        session.mood = mood
        session.sessionCode = sessionCode
        session.user = Int16(AuthenticationService.shared.userId!)
        session.date = Date() as NSDate

        DataManager.shared.saveContext()
        
        // Reset class after item is persisted.
        reinitializeSession()
    }
}
