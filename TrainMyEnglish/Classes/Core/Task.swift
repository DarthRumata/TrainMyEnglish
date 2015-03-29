//
//  Task.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 29.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

class Task {
    var description: String
    var rules: Array<Rule>
    var words: Array<Word>
    
    init(description: String, rules: Array<Rule>, words: Array<Word>) {
        self.description = description
        self.rules = rules
        self.words = words
    }
}