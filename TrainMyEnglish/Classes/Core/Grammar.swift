//
//  Grammar.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 29.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

enum Tense: String {
    case Present = "Present"
    case Past = "Past"
    case Future = "Future"
}

enum Aspect: String {
    case Simple = "Simple"
    case Continuous = "Continuous"
    case Perfect = "Perfect"
    case PerfectContinuous = "Perfect Continuous"
}

enum SentenceMood: String {
    case Narrative = "Narrative"
    case Negative = "Negative"
    case Interrogative = "Interrogative"
    case Imperative = "Imperative"
}

class Grammar {
    
    static let allTenses = [Tense.Past.rawValue, Tense.Present.rawValue, Tense.Future.rawValue]
    static let allAspects = [Aspect.Simple.rawValue, Aspect.Continuous.rawValue, Aspect.Perfect.rawValue, Aspect.PerfectContinuous.rawValue]
    static let allMoods = [SentenceMood.Narrative.rawValue, SentenceMood.Negative.rawValue, SentenceMood.Interrogative.rawValue]

}

class GrammarForm {
    var tense: Tense
    var aspect: Aspect
    var mood: SentenceMood
    
    init(tense: Tense, aspect: Aspect, mood: SentenceMood) {
        self.tense = tense
        self.aspect = aspect
        self.mood = mood
    }
}