//
//  Date+Extensions.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 6/19/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import Foundation

extension Date {
    func toISOString() -> String {
        let df = DateFormatter()
        df.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        df.dateFormat = "y-MM-dd H:m:ss.SSSS"
        return df.string(from: self)
    }
    
    func toDateString() -> String {
        let df = DateFormatter()
        df.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: self)
    }
    
    func toDateCodeString() -> String {
        let df = DateFormatter()
        df.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        df.dateFormat = "yyyyMMdd"
        return df.string(from: self)
    }
}
