//
//  Array+Extensions.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 08.06.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//
import Foundation

extension Array {
    func splitBy(subSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: subSize).map {
            Array(self[$0..<Swift.min($0 + subSize, self.count)])
        }
    }
    
    // Fisher - Yates Shuffle
    mutating func shuffle() {
        if self.count < 2 { return }
        
        for i in 0..<self.count - 1 {
            let j = Int(arc4random_uniform(UInt32(self.count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

