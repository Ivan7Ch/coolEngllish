//
//  PlaylistsCacheHelper.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 14.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


class PlaylistsCacheHelper {
    
    static let shared = PlaylistsCacheHelper()
    
    func getPlaylistsId() -> [String] {
        let defaults = UserDefaults.standard
        let stringPlaylists = defaults.stringArray(forKey: "playlists") ?? [String]()
        
        return stringPlaylists
    }
    
    func addNewPlaylist(playlist: String) {
        var arr = getPlaylistsId()
        arr.append(playlist)
        
        let defaults = UserDefaults.standard
        defaults.set(arr, forKey: "playlists")
    }
}
