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
    
}