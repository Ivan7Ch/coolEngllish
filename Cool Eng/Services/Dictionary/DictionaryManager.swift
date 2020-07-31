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
    var progress: Int = 0
}


fileprivate struct SimpleWord: Codable {
    var o: String
    var tr: String = ""
    var ts: String = ""
    var s: String = ""
}


class RealmWord: Object {
    @objc dynamic var id = 0
    @objc dynamic var original = ""
    @objc dynamic var translation = ""
    @objc dynamic var transcription = ""
    @objc dynamic var sentence = ""
    @objc dynamic var progress = 0
    
    func setup(with word: Word) {
        self.id = word.id
        self.original = word.original
        self.translation = word.translation
        self.transcription = word.transcription
        self.sentence = word.sentence
        self.progress = word.progress
    }
}


class DictionaryManager {
    
    static let shared = DictionaryManager()
    
    private init() { }
    
    var start: CFAbsoluteTime!
    
    func setup() {
        start = CFAbsoluteTimeGetCurrent()
        
        let filepath = Bundle.main.path(forResource: "dictionary", ofType: "txt")!
        let contents = try! String(contentsOfFile: filepath)
        let jsonData = contents.data(using: .utf8)!
        let objects = try! JSONDecoder().decode([SimpleWord].self, from: jsonData)
        
        var correctWords = [Word]()
        for (i, v) in objects.enumerated() {
            let word = Word(id: i, original: v.o, translation: v.tr, transcription: v.ts, sentence: v.s, progress: 0)
            correctWords.append(word)
        }
        
        
        DispatchQueue.global(qos: .utility).async {
            self.saveWordsToRealm(correctWords)
        }
    }
    
    
    func getWord(_ original: String) -> Word? {
        let realm = try! Realm()
        
        guard let word = realm.objects(RealmWord.self).filter("original == '\(original)'").first else { return nil }
        
        return Word(id: word.id, original: word.original, translation: word.translation)
    }
    
    
    func getAllWords() -> [Word] {
        var res = [Word]()
        
        let realm = try! Realm()
        
        let words = realm.objects(RealmWord.self)
        
        for i in words {
            let w = Word(id: i.id, original: i.original, translation: i.translation, transcription: i.transcription, sentence: i.sentence, progress: i.progress)
            res.append(w)
        }
        
        return res
    }
    
    
    func getWordsForStudy() -> [Word] {
        var res = [Word]()
        let realm = try! Realm()
        
        let words = realm.objects(RealmWord.self).filter("progress == 0")
        
        for i in words {
            res.append(Word(id: i.id, original: i.original, translation: i.translation, transcription: i.transcription, sentence: i.sentence, progress: i.progress))
        }
        
        return res
    }
    
    
    func getWordsForRecall() -> [Word] {
        var res = [Word]()
        let realm = try! Realm()
        
        let words = realm.objects(RealmWord.self).filter("progress == 50")
        
        for i in words {
            res.append(Word(id: i.id, original: i.original, translation: i.translation, transcription: i.transcription, sentence: i.sentence, progress: i.progress))
        }
        
        return res
    }
    
    
    func getLearnedWords() -> [Word] {
        var res = [Word]()
        let realm = try! Realm()
        
        let words = realm.objects(RealmWord.self).filter("progress > 50")
        
        for i in words {
            res.append(Word(id: 0, original: i.original, translation: i.translation))
        }
        
        return res
    }
    
    
    func getRandWords() -> [Word] {
        var res = [Word]()
        let realm = try! Realm()
        
        let words = realm.objects(RealmWord.self).filter("progress > 50")
        
        for i in words {
            res.append(Word(id: 0, original: i.original, translation: i.translation))
        }
        
        if res.count < 6 {
            for _ in 0..<6 {
                let ind = Int.random(in: 0..<5000)
                let word = realm.objects(RealmWord.self).filter("id == \(ind)").first
                
                res.append(Word(id: 0, original: "", translation: word?.translation ?? ""))
            }
        }
        
        return res
    }
    
    
    func getWordsFor(level: EnglishLevel) -> [Word] {
        var res = [Word]()
        let realm = try! Realm()
        
        var minId = 0
        
        switch level {
        case .beginer:
            minId = 400
        case .intermediate:
            minId = 3000
        case .advanced:
            minId = 8000
        case .native:
            minId = 10000
        }
        
        let words = realm.objects(RealmWord.self).filter("progress == -1").filter("id > \(minId)")
        
    
        for i in 0..<words.count {
            if i >= 99 { break }
            
            let word = words[i]
            res.append(Word(id: word.id, original: word.original, translation: word.translation, transcription: word.transcription, sentence: word.sentence, progress: word.progress))
        }
        
        return res
    }
    
    
    func addToDictionary(ids: [Int]) {
        updateProgress(progress: 0, in: ids)
    }
    
    
    func addToRecallList(ids: [Int]) {
        updateProgress(progress: 50, in: ids)
    }
    
    
    func markAsLearned(ids: [Int]) {
        updateProgress(progress: 100, in: ids)
    }
    
    
    private func updateProgress(progress: Int, in ids: [Int]) {
        let realm = try! Realm()
        
        for i in ids {
            guard let word = realm.objects(RealmWord.self).filter("id == \(i)").first else { break }
            try! realm.write {
                word.progress = progress
            }
        }
    }
    
    
    private func saveWordsToRealm(_ words: [Word]) {
        let realm = try! Realm()
        
        let index = getAllWords().count
        
        var realmArr = [RealmWord]()
        
        for i in index..<words.count {
            var word = words[i]
            let realmWord = RealmWord()
            word.progress = -1
            realmWord.setup(with: word)
            realmArr.append(realmWord)
        }
        
        try! realm.write {
            realm.add(realmArr)
        }

        
        UserDefaults.standard.set(true, forKey: "isDictionarySettuped")
        let diff = CFAbsoluteTimeGetCurrent() - start
        print("Took \(diff) seconds")
    }
}


var top400 = ["the", "be", "to", "of", "and", "a", "in", "that", "have", "I", "it", "for", "not", "on", "with", "he", "as", "you", "do", "at", "this", "but", "his", "by", "from", "they", "we", "say", "her", "she", "or", "an", "will", "my", "one", "all", "would", "there", "their", "what", "so", "up", "out", "if", "about", "who", "get", "which", "go", "me", "when", "make", "can", "like", "time", "no", "just", "him", "know", "take", "people", "into", "year", "your", "good", "some", "could", "them", "see", "other", "than", "then", "now", "look", "only", "come", "its", "over", "think", "also", "back", "after", "use", "two", "how", "our", "work", "first", "well", "way", "even", "new", "want", "because", "any", "these", "give", "day", "most", "us", "time", "year", "people", "way", "day", "man", "thing", "woman", "life", "child", "world", "school", "state", "family", "student", "group", "country", "problem", "hand", "part", "place", "case", "week", "company", "system", "program", "question", "work", "government", "number", "night", "point", "home", "water", "​room", "mother", "area", "money", "story", "fact", "month", "lot", "right", "study", "book", "eye", "job", "word", "business", "issue", "side", "kind", "head", "house", "service", "friend", "father", "power", "hour", "game", "line", "end", "member", "law", "car", "city", "community", "name", "president", "team", "minute", "idea", "kid", "body", "information", "back", "parent", "face", "others", "level", "office", "door", "health", "person", "art", "war", "history", "party", "result", "change", "morning", "reason", "research", "girl", "guy", "moment", "air", "teacher", "force", "education", "be", "have", "do", "say", "go", "can", "get", "would", "make", "know", "will", "think", "take", "see", "come", "could", "want", "look", "use", "find", "give", "tell", "work", "may", "should", "call", "try", "ask", "need", "feel", "become", "leave", "put", "mean", "keep", "let", "begin", "seem", "help", "talk", "turn", "start", "might", "show", "hear", "play", "run", "move", "like", "live", "believe", "hold", "bring", "happen", "must", "write", "provide", "sit", "stand", "lose", "pay", "meet", "include", "continue", "set", "learn", "change", "lead", "​understand", "watch", "follow", "stop", "create", "speak", "read", "allow", "add", "spend", "grow", "open", "walk", "win", "offer", "remember", "love", "consider", "appear", "buy", "wait", "serve", "die", "send", "expect", "build", "stay", "fall", "cut", "reach", "kill", "remain", "other", "new", "good", "high", "old", "great", "big", "American", "small", "large", "national", "young", "different", "black", "long", "little", "important", "political", "bad", "white", "real", "best", "right", "social", "only", "public", "sure", "low", "early", "able", "human", "local", "late", "hard", "major", "better", "economic", "strong", "possible", "whole", "free", "military", "true", "federal", "international", "full", "special", "easy", "clear", "recent", "certain", "personal", "open", "red", "difficult", "available", "likely", "short", "single", "medical", "current", "wrong", "private", "past", "foreign", "fine", "common", "poor", "natural", "significant", "similar", "hot", "dead", "central", "happy", "serious", "ready", "simple", "left", "physical", "general", "environmental", "financial", "blue", "democratic", "dark", "various", "entire", "close", "legal", "religious", "cold", "final", "main", "green", "nice", "huge", "popular", "traditional", "cultural" ]
