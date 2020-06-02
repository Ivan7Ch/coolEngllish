//
//  VocabularyBoxExtension.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 02.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


// MARK: -  Vocabulary box
extension VideoPlayerViewController {
   
    func wordsForLearning() {
        DispatchQueue.global(qos: .default).async {
            
            var res = [Word]()
            var subs = ""
            
            for i in self.video.subtitles {
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
            for (index, value) in self.realmWords.enumerated() {
                realmWordsDict[value.original] = index
            }
            
            for i in dict.sorted(by: { $0.1 < $1.1 }) {
                if let ind = realmWordsDict[i.key] {
                    let rw = self.realmWords[ind]
                    if rw.progress != -1 { continue }
                    if !top400.contains(String(i.key)) {
                        res.append(rw)
                    }
                }
            }
            
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "VocabularyBoxViewController") as! VocabularyBoxViewController
                vc.words = res
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
