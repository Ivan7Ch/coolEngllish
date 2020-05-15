//
//  SubtitlesFirebaseHelper.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 28.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import Firebase


class SubtitlesFirebaseHelper {
    
    static let shared = SubtitlesFirebaseHelper()
    
    private init() { }
    
    let db = Firestore.firestore()
    
    
    func fetchSubtitles(videoId: Int, callback: @escaping ([SubtitleModel]) -> Void) {
        
        let docRef = db.collection("subtitles").whereField("videoId", isEqualTo: videoId)
        
        docRef.getDocuments { (querySnapshot, err) in
            if err != nil { return }
            
            var res = [SubtitleModel]()
            for doc in querySnapshot!.documents {
                if let subtitles = self.parseData(dict: doc.data()) {
                    res = subtitles
                }
            }
            callback(res)
        }
    }
    
    
    private func parseData(dict: [String: Any]) -> [SubtitleModel]? {
        guard let subtitlesDict = dict["subtitles"] as? [[String: Any]]
            else { return nil }
        
        var subtitles = [SubtitleModel]()
        for i in subtitlesDict {
            if let sub = parseSubtitleData(dict: i) {
                subtitles.append(sub)
            }
        }
        
        return subtitles
    }
    
    
    private func parseSubtitleData(dict: [String: Any]) -> SubtitleModel? {
        guard let start = dict["start"] as? String,
            let eng = dict["text"] as? String
        else { return nil }
        
        return SubtitleModel(start: Double(start) ?? 0, eng: eng, ru: "")
    }
}

