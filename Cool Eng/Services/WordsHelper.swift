//
//  WordsHelper.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 23.02.2021.
//  Copyright © 2021 Ivan Chernetskiy. All rights reserved.
//

import Foundation

class WordsHelper {
    
    var realmWords = [Word]()
    static let shared = WordsHelper()
    
    
    private init() {
        realmWords = DictionaryManager.shared.getAllWords()
    }
    
    
    func wordsFromVideo(video: VideoModel) -> [Word] {
        var res = [Word]()
        var subs = ""
        
        for i in video.subtitles {
            subs += i.eng + " "
        }
        
        let words = subs.split{ $0.isWhitespace }
        
        var dict = [String: Int]()
        for i in words {
            let key = String(i)
            if let val = dict[key] {
                dict[key] = val + 1
            } else {
                dict[key] = 1
            }
        }
        
        var realmWordsDict = [String: Int]()
        for (index, value) in realmWords.enumerated() {
            realmWordsDict[value.original] = index
        }
        
        for i in dict.sorted(by: { $0.1 < $1.1 }) {
            if let ind = realmWordsDict[i.key] {
                let rw = realmWords[ind]
                if rw.progress != -1 { continue }
                if !top400.contains(String(i.key)) {
                    res.append(rw)
                }
            }
        }
        
        return res
    }
}
