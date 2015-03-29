//
//  WordsHandler.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 15.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

class WordsHandler {

    //MARK: Singleton

    private static var instance: WordsHandler!
    private static var dispatch_token: dispatch_once_t = 0

    private var nouns: Array<Word>?
    private var pronouns: Array<Word>?
    private var verbs: Array<Word>?

    private init() {
    }

    class var sharedInstance: WordsHandler {
        if instance == nil {
            dispatch_once(&dispatch_token, {
                self.instance = WordsHandler()
            })
        }

        return instance
    }

    //MARK: Public

    func getNouns() -> Array<Word>? {
        return self.nouns
    }

    func getPronouns() -> Array<Word>? {
        return self.pronouns
    }

    func getVerbs() -> Array<Word>? {
        return self.verbs
    }

    func getAllWords() -> Array<Word> {
        var all: Array<Word> = []

        if self.nouns != nil {
            all += self.nouns! as Array<Word>
        }

        if self.pronouns != nil {
            all += self.pronouns! as Array<Word>
        }

        if self.verbs != nil {
            all += self.verbs! as Array<Word>
        }

        return all
    }

//MARK: fill content

    func loadContent(content: NSDictionary?) {
        println("config= \(content!)")
        if content == nil {
            println("Cannot load nil content")
            return
        }

        let nouns: Array<Dictionary<String, AnyObject>> = content!.objectForKey("nouns") as! Array
        for rawNoun in nouns {
            let noun = WordsParser.parseWord(rawNoun, type: WordType.Noun)

            if self.nouns == nil {
                self.nouns = [noun]
            } else {
                self.nouns!.append(noun)
            }
        }
        println(self.nouns)

        let pronouns: Array<Dictionary<String, AnyObject>> = content!.objectForKey("pronouns") as! Array
        for rawPronoun in pronouns {
            let pronoun = WordsParser.parseWord(rawPronoun, type: WordType.Pronoun)

            if self.pronouns == nil {
                self.pronouns = [pronoun]
            } else {
                self.pronouns!.append(pronoun)
            }
        }
        println(self.pronouns)

        let verbs: Array<Dictionary<String, AnyObject>> = content!.objectForKey("verbs") as! Array
        for rawVerb in verbs {
            let verb = WordsParser.parseWord(rawVerb, type: WordType.Verb)

            if self.verbs == nil {
                self.verbs = [verb]
            } else {
                self.verbs!.append(verb)
            }
        }
        println(self.verbs)
    }

    func loadByPath(path: String) {
        if let content = NSDictionary(contentsOfFile: path) {
            self.loadContent(content)
        } else {
            println("Cannot load content by path \(path)")
        }
    }
}

private class WordsParser {

    class func parseWord(rawData: Dictionary<String, AnyObject>, type: WordType) -> Word {
        let forms = rawData["forms"] as! Dictionary<String, String>
        let translation = rawData["translation"] as! String
        let word = Word(forms: forms, translation: translation, type: type)
        if let tags = rawData["tags"] as? Array<String> {
            word.tags = tags
        }
        return word
    }
    
    

}
