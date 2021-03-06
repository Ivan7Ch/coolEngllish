//
//  PlaylistFirebaseHelper.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import Firebase


class PlaylistFirebaseHelper {
    
    static let shared = PlaylistFirebaseHelper()
    
    private init() { }
    
    let db = Firestore.firestore()
    
    
    func fetchPlaylists(callback: @escaping ([PlaylistModel]) -> Void) {
        let docRef = db.collection("playlists")
        docRef.getDocuments { (querySnapshot, err) in
            if err != nil { return }
            var playlists: [PlaylistModel] = []
            for document in querySnapshot!.documents {
                if let playlist = self.parsePlaylistData(dict: document.data()) {
                    playlists.append(playlist)
                }
            }
            callback(playlists)
        }
    }
    
    
    func fetchPlaylist(id: String, callback: @escaping (PlaylistModel?) -> Void) {
        let docRef = db.collection("playlists").whereField("id", isEqualTo: id)
        
        docRef.getDocuments { (querySnapshot, err) in
            if err != nil { return }
            
            var playlists: [PlaylistModel] = []
            for document in querySnapshot!.documents {
                if let playlist = self.parsePlaylistData(dict: document.data()) {
                    playlists.append(playlist)
                }
            }
            if let playlist = playlists.first {
                callback(playlist)
            } else {
                callback(nil)
            }
        }
    }
    
    
    func increaseViews(playlist id: Int) {
        let docRef = db.collection("playlists").document("\(id)")
        docRef.updateData(["views":FieldValue.increment(Int64(1))])
    }
    
    
    private func parsePlaylistData(dict: [String: Any]) -> PlaylistModel? {
        guard let id = dict["id"] as? Double,
            let name = dict["name"] as? String,
            let placeholder = dict["placeholder"] as? String else { return nil }
        
        let views = (dict["views"] as? Double) ?? 0
        let isFree = (dict["isFree"] as? Bool) ?? true
        var videosCount = 0
        if let v = dict["videosCount"] as? Double {
            videosCount = Int(v)
        }
        
        return PlaylistModel(id: Int(id), name: name, placeholder: placeholder, views: Int(views), videosCount: videosCount, isFree: isFree)
    }
}


