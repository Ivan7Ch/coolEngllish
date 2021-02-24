//
//  SubtitlesExtension.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 02.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


// MARK: - Subtitles helper
extension VideoPlayerViewController {
    func fetchSubtitles() {
        SubtitlesFirebaseHelper.shared.fetchSubtitles(videoId: video.id, lang: "en", callback: { sub in
            self.video.subtitles = sub
            
            DispatchQueue.global(qos: .default).async {
                self.setupSubtitles()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            self.wordsForLearning()
        })
        
        SubtitlesFirebaseHelper.shared.fetchSubtitles(videoId: video.id, lang: "ru", callback: { sub in
            self.foreignSubs = sub
            
            self.setupForeignSubtitles()
        })
    }
    
    
    func setupSubtitles() {
        var newSubs = [SubtitleModel]()
        for (ind, sub) in video.subtitles.enumerated() {
            var engStr = " " + sub.eng
            var ruStr = ""
            if ind < foreignSubs.count {
                ruStr = sub.ru
            }
            
            if sub.eng.last?.isNewline ?? false {
                engStr = String(sub.eng.dropLast())
                engStr = convertText(engStr)
            }
            
            if sub.ru.last?.isNewline ?? false {
                ruStr = String(sub.ru.dropLast())
            }
            
            let newSub = SubtitleModel(start: sub.start, eng: engStr, ru: ruStr)
            newSubs.append(newSub)
        }
        video.subtitles = newSubs
        
        startTimes = []
        for i in video.subtitles {
            startTimes.append(i.start)
        }
        
        videoLastSubtitleTime = startTimes.last ?? 0
        setupForeignSubtitles()
    }
    
    
    private func printSubs(subs: [SubtitleModel]) {
        for i in subs {
            print("{")
            print("\"key\": \(i.start),")
            print("\"value\": \"\(i.eng)\"")
            print("},")
        }
    }
    
    
    func convertText(_ text: String) -> String {
        var res = ""
        let div = "​"
        
        let words = text.split { $0.isWhitespace }
        var dict = [String: String]()
        
        for i in WordsHelper.shared.realmWords {
            dict[i.original] = i.translation
        }
        
        for i in words {
            let w = i.replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: ",", with: "").lowercased()
            if let _ = dict[String(w)] {
                res = res + " \(i)"
            } else {
                res = res + " \(div)\(i)"
            }
        }
        
        return res
    }
    
    
    func setupForeignSubtitles() {
        for i in 0..<self.video.subtitles.count {
            if i >= foreignSubs.count { break }
            self.video.subtitles[i].ru = foreignSubs[i].eng
        }
    }
}
