//
//  TrialSettings.swift
//  TapSensing
//
//  Created by Emanuel Schmitt on 7/21/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

public struct GridShape {
    var height: Int
    var width: Int
    
    init(height: Int, width: Int) {
        self.height = height
        self.width = width
    }
}

public struct TrialSettings {
    var shapes: [GridShape]
    var repeats: Int
    
    init(shapes: [GridShape], repeats: Int) {
        self.shapes = shapes
        self.repeats = repeats
    }
}
