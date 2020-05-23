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
