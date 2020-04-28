//
//  VideoFirebaseHelper.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import Firebase


class VideoFirebaseHelper {
    
    static let shared = VideoFirebaseHelper()
    
    private init() { }
    
    let db = Firestore.firestore()
    
    
    func fetchVideos(playlistId: Int, callback: @escaping ([VideoModel]) -> Void) {
        
        let docRef = db.collection("videos").whereField("playlist", isEqualTo: playlistId)
        
        docRef.getDocuments { (querySnapshot, err) in
            if err != nil { return }
            
            var videos = [VideoModel]()
            for doc in querySnapshot!.documents {
                if let video = self.parseVideoData(dict: doc.data()) {
                    videos.append(video)
                }
            }
            callback(videos)
        }
    }
    
    
    private func parseVideoData(dict: [String: Any]) -> VideoModel? {
        guard let id = dict["id"] as? Double,
            let name = dict["name"] as? String,
            let placeholder = dict["placeholder"] as? String,
            let playlist = dict["playlist"] as? Double,
            let url = dict["url"] as? String,
            let subtitlesId = dict["subtitles"] as? Double
        else { return nil }
        
//        var subtitles = [SubtitleModel]()
//        for i in subtitlesDict {
//            if let sub = parseSubtitleData(dict: i) {
//                subtitles.append(sub)
//            }
//        }
        
        return VideoModel(id: Int(id), name: name, playlist: Int(playlist), placeholder: placeholder, subtitlesId: Int(subtitlesId), url: url)
    }
    
    
    private func parseSubtitleData(dict: [String: Any]) -> SubtitleModel? {
        guard let start = dict["start"] as? Double,
            let eng = dict["eng"] as? String,
            let ru = dict["ru"] as? String
        else { return nil }
        
        return SubtitleModel(start: start, eng: eng, ru: ru)
    }
}
