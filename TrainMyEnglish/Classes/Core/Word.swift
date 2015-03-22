//
//  Word.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 15.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

class Word {
    var base: String
    var translation: String
    var tags: Array<String>?

    init(base: String, translation: String) {
        self.base = base
        self.translation = translation
    }

}
