//
//  Random.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 19.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

class Random {

    class func rndInt(from: Int, _ to: Int) -> Int {
        let argument = UInt32(to - from + 1)
        return Int(arc4random_uniform(argument)) + from
    }

    class func rndDouble(from: Double, _ to: Double) -> Double {
        return drand48() * (to - from) + from
    }

    class func rndBool() -> Bool {
        return Random.rndInt(0, 1) == 1
    }

    class func rndBool(probability: Double) -> Bool {
        return Random.rndDouble(0, 1) <= probability
    }

    class func rndOneOf<T>(array: Array<T>) -> T {
        return array[Random.rndInt(0, array.count - 1)]
    }

}