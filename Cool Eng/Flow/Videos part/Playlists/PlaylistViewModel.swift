//
//  PlaylistViewModel.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


protocol PlaylistDelegate {
    func reloadData()
}


class PlaylistViewModel {
    
    var playlists = [PlaylistModel]()
    
    var delegate: PlaylistDelegate
    
    init(delegate: PlaylistDelegate) {
        self.delegate = delegate
        fetchPlaylists()
    }
    
    func fetchPlaylists() {
        PlaylistFirebaseHelper.shared.fetchPlaylists(callback: { playlists in
            let shouldIgnore = [2, 3, 9]
            self.playlists = playlists.filter{ !shouldIgnore.contains($0.id) }.sorted(by: {$0.isFree && !$1.isFree})
            self.delegate.reloadData()
        })
    }
}
