//
//  QuestionViewModel.swift
//  BackgroundSensing
//
//  Created by Lukas Würzburger on 5/27/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import Foundation

class QuestionViewModel {

    struct State {
        var title: String
        var numberOfItems: Int
        var iconFileNames: [String]
        var itemTitles: [String]
    }

    var state = State(
        title: "",
        numberOfItems: 0,
        iconFileNames: [],
        itemTitles: []
    ) {
        didSet {
            callback(state)
        }
    }
    var callback: (State) -> ()

    init(itemKeys: [String], callback: @escaping (State) -> ()) {

        state.numberOfItems = itemKeys.count
        state.iconFileNames = itemKeys.map({ "icon-\($0.lowercased())" })
        state.itemTitles    = itemKeys.map({
            NSLocalizedString("question-item-label-\($0.lowercased())", comment: "")
        })

        self.callback = callback
        callback(state)
    }
}
