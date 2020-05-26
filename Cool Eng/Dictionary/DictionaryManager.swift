//
//  DictionaryManager.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 22.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import Foundation
import RealmSwift


struct Word: Codable {
    var id: Int
    var original: String
    var translation: String = ""
    var transcription: String = ""
    var sentence: String = ""
}

class RealmWord: Object {
    @objc dynamic var original = ""
    @objc dynamic var translation = ""
}

struct SWord {
    var original = ""
    var translation = ""
}


class DictionaryManager {
    
    static let shared = DictionaryManager()
    
    private init() { }
    
    var start: CFAbsoluteTime!
    
    func setup() {
        start = CFAbsoluteTimeGetCurrent()
        
        let filepath = Bundle.main.path(forResource: "dict_ua", ofType: "txt")!
        let contents = try! String(contentsOfFile: filepath)
        let jsonData = contents.data(using: .utf8)!
        let objects = try! JSONDecoder().decode([Word].self, from: jsonData)
        
        DispatchQueue.global(qos: .background).async {
            self.saveWordsToRealm(objects)
        }
    }
    
    
    func getSimpleWord(_ original: String) -> Word? {
        let realm = try! Realm()
        
        guard let word = realm.objects(RealmWord.self).filter("original == '\(original)'").first else { return nil }
        
        return Word(id: 0, original: word.original, translation: word.translation)
    }
    
    func getAllWords() -> [Word] {
        var res = [Word]()
        
        let realm = try! Realm()
        
        let words = realm.objects(RealmWord.self)
        
        for i in words {
            res.append(Word(id: 0, original: i.original, translation: i.translation))
        }
        
        return res
    }
    
    
    private func saveWordsToRealm(_ words: [Word]) {
        let realm = try! Realm()
        
        for w in words {
            let realmWord = RealmWord()
            realmWord.original = w.original
            realmWord.translation = w.translation
            try! realm.write {
                realm.add(realmWord)
            }
        }
        UserDefaults.standard.set(true, forKey: "isDictionarySettuped")
        let diff = CFAbsoluteTimeGetCurrent() - start
        print("Took \(diff) seconds")
    }
}


var top400 = ["the", "be", "to", "of", "and", "a", "in", "that", "have", "I", "it", "for", "not", "on", "with", "he", "as", "you", "do", "at", "this", "but", "his", "by", "from", "they", "we", "say", "her", "she", "or", "an", "will", "my", "one", "all", "would", "there", "their", "what", "so", "up", "out", "if", "about", "who", "get", "which", "go", "me", "when", "make", "can", "like", "time", "no", "just", "him", "know", "take", "people", "into", "year", "your", "good", "some", "could", "them", "see", "other", "than", "then", "now", "look", "only", "come", "its", "over", "think", "also", "back", "after", "use", "two", "how", "our", "work", "first", "well", "way", "even", "new", "want", "because", "any", "these", "give", "day", "most", "us", "time", "year", "people", "way", "day", "man", "thing", "woman", "life", "child", "world", "school", "state", "family", "student", "group", "country", "problem", "hand", "part", "place", "case", "week", "company", "system", "program", "question", "work", "government", "number", "night", "point", "home", "water", "​room", "mother", "area", "money", "story", "fact", "month", "lot", "right", "study", "book", "eye", "job", "word", "business", "issue", "side", "kind", "head", "house", "service", "friend", "father", "power", "hour", "game", "line", "end", "member", "law", "car", "city", "community", "name", "president", "team", "minute", "idea", "kid", "body", "information", "back", "parent", "face", "others", "level", "office", "door", "health", "person", "art", "war", "history", "party", "result", "change", "morning", "reason", "research", "girl", "guy", "moment", "air", "teacher", "force", "education", "be", "have", "do", "say", "go", "can", "get", "would", "make", "know", "will", "think", "take", "see", "come", "could", "want", "look", "use", "find", "give", "tell", "work", "may", "should", "call", "try", "ask", "need", "feel", "become", "leave", "put", "mean", "keep", "let", "begin", "seem", "help", "talk", "turn", "start", "might", "show", "hear", "play", "run", "move", "like", "live", "believe", "hold", "bring", "happen", "must", "write", "provide", "sit", "stand", "lose", "pay", "meet", "include", "continue", "set", "learn", "change", "lead", "​understand", "watch", "follow", "stop", "create", "speak", "read", "allow", "add", "spend", "grow", "open", "walk", "win", "offer", "remember", "love", "consider", "appear", "buy", "wait", "serve", "die", "send", "expect", "build", "stay", "fall", "cut", "reach", "kill", "remain", "other", "new", "good", "high", "old", "great", "big", "American", "small", "large", "national", "young", "different", "black", "long", "little", "important", "political", "bad", "white", "real", "best", "right", "social", "only", "public", "sure", "low", "early", "able", "human", "local", "late", "hard", "major", "better", "economic", "strong", "possible", "whole", "free", "military", "true", "federal", "international", "full", "special", "easy", "clear", "recent", "certain", "personal", "open", "red", "difficult", "available", "likely", "short", "single", "medical", "current", "wrong", "private", "past", "foreign", "fine", "common", "poor", "natural", "significant", "similar", "hot", "dead", "central", "happy", "serious", "ready", "simple", "left", "physical", "general", "environmental", "financial", "blue", "democratic", "dark", "various", "entire", "close", "legal", "religious", "cold", "final", "main", "green", "nice", "huge", "popular", "traditional", "cultural" ]
