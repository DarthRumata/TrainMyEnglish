//
//  Noun.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 15.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

class Noun: Word {
    var plural: String

    init(base: String, translation: String, plural: String) {
        self.plural = plural
        super.init(base: base, translation: translation)
    }

    convenience init(word: Word, plural: String) {
        self.init(base: word.base, translation: word.translation, plural: plural)
    }
}
