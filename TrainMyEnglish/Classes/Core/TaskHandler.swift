//
//  TaskHadler.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 29.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

class TaskHandler {
    //MARK: Singleton
    
   private static var instance: TaskHandler!
   private static var dispatch_token: dispatch_once_t = 0
    
    private init() {
    }
    
    class var sharedInstance: TaskHandler {
        if instance == nil {
            dispatch_once(&dispatch_token, {
                self.instance = TaskHandler()
            })
        }
        
        return instance
    }
    
    //MARK: Public
    
    func nextTask() -> Task {
        //TODO demo task
        return Task(description: self.makeDescription(Tense.Present, Aspect.Simple, SentenceMood.Narrative), rules: [], words: WordsHandler.sharedInstance.getAllWords())
    }
    
    private func makeDescription(tense: Tense, _ aspect: Aspect, _ mood: SentenceMood) -> String {
        return "Please make " + mood.rawValue + " sentence in " + tense.rawValue + " " + aspect.rawValue
    }
    
}