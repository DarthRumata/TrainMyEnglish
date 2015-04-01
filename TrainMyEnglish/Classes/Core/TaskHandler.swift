//
//  TaskHadler.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 29.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

enum TaskMode: Int {
    case Sandbox = 0
}

class TaskHandler {
    //MARK: Singleton
    
    private static var instance: TaskHandler!
    private static var dispatch_token: dispatch_once_t = 0
    
    private var taskMode = TaskMode.Sandbox
    private var taskQueue: Queue<Task>!
    
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
    
    func nextTask() -> Task? {
        //TODO demo task
        switch (self.taskMode) {
        case .Sandbox:
           return taskQueue.deQueue()
        }
    }
    
    func pushSandboxTask(fromSentenceGrammarForm form: GrammarForm) {
        self.taskMode = TaskMode.Sandbox
        self.taskQueue.clear()
        let task = Task(description: self.makeDescription(form.tense , form.aspect, form.mood), rules: [], words: WordsHandler.sharedInstance.getAllWords())
        self.taskQueue.enQueue(task)
    }
    
    private func makeDescription(tense: Tense, _ aspect: Aspect, _ mood: SentenceMood) -> String {
        return "Please make " + mood.rawValue + " sentence in " + tense.rawValue + " " + aspect.rawValue
    }
    
}