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

    private struct Instance {
        static var instance: WordsHandler!
        static var dispatch_token: dispatch_once_t = 0
    }

    private var nouns: Array<Noun>?
    private var pronouns: Array<Word>?
    private var verbs: Array<Verb>?

    private init() {
    }

    class var sharedInstance: WordsHandler {
        if Instance.instance == nil {
            dispatch_once(&Instance.dispatch_token, {
                Instance.instance = WordsHandler()
            })
        }

        return Instance.instance
    }

    //MARK: Public

    func getNouns() -> Array<Noun>? {
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
            let noun = WordsParser.parseNoun(rawNoun)

            if self.nouns == nil {
                self.nouns = [noun]
            } else {
                self.nouns!.append(noun)
            }
        }
        println(self.nouns)

        let pronouns: Array<Dictionary<String, AnyObject>> = content!.objectForKey("pronouns") as! Array
        for rawPronoun in pronouns {
            let pronoun = WordsParser.parseWord(rawPronoun)

            if self.pronouns == nil {
                self.pronouns = [pronoun]
            } else {
                self.pronouns!.append(pronoun)
            }
        }
        println(self.pronouns)

        let verbs: Array<Dictionary<String, AnyObject>> = content!.objectForKey("verbs") as! Array
        for rawVerb in verbs {
            let verb = WordsParser.parseVerb(rawVerb)

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

    class func parseWord(rawData: Dictionary<String, AnyObject>) -> Word {
        let base = rawData["base"] as! String
        let translation = rawData["translation"] as! String
        let word = Word(base: base, translation: translation)
        if let tags = rawData["tags"] as? Array<String> {
            word.tags = tags
        }
        return word
    }

    class func parseNoun(rawData: Dictionary<String, AnyObject>) -> Noun {
        let word = self.parseWord(rawData)
        let plural = rawData["plural"] as! String
        let noun = Noun(word: word, plural: plural)
        return noun
    }

    class func parseVerb(rawData: Dictionary<String, AnyObject>) -> Verb {
        let word = self.parseWord(rawData)
        let forms = rawData["forms"] as! Dictionary<String, String>
        let verb = Verb(word: word, forms: forms)
        return verb
    }

}
