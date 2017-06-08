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
        return stride(from: 0, to: self.count, by: subSize).map { startIndex in
            if let endIndex = self.index(startIndex, offsetBy: subSize, limitedBy: self.count) {
                return Array(self[startIndex ..< endIndex])
            }
            return Array()
        }
    }
}

