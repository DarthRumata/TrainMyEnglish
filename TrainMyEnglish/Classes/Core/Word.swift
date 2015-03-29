//
//  Word.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 15.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

enum WordType {
    case Noun, Pronoun, Verb, Adverb, Adjective, Preposition
}

class Word {
    var forms: Dictionary<String, String>
    var translation: String
    var tags: Array<String>?
    var type: WordType
    
    var base: String {
        return self.forms["base"]!
    }

    init(forms: Dictionary<String, String>, translation: String, type: WordType) {
        self.forms = forms
        self.translation = translation
        self.type = type
    }
    
    func formList(except: String) -> Array<String> {
        return self.forms.values.array.filter{ $0 != except }
    }

}
