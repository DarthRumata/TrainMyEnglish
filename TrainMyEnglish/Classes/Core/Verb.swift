//
//  Verb.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 15.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

class Verb: Word {
    var forms: Dictionary<String, String>

    init(base: String, translation: String, forms: Dictionary<String, String>) {
        self.forms = forms
        super.init(base: base, translation: translation)
    }

    convenience init(word: Word, forms: Dictionary<String, String>) {
        self.init(base: word.base, translation: word.translation, forms: forms)
    }

}