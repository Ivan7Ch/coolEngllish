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
    
    
    private func parsePlaylistData(dict: [String: Any]) -> PlaylistModel? {
        guard let id = dict["id"] as? String,
            let name = dict["name"] as? String,
            let placeholder = dict["placeholder"] as? String else { return nil }
        
        return PlaylistModel(id: id, name: name, placeholder: placeholder)
    }
    
}


