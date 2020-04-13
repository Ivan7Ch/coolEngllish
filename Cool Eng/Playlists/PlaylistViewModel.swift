//
//  PlaylistViewModel.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


class PlaylistViewModel {
    
    var playlists = [PlaylistModel]()
    
    init() {
        fetchPlaylists()
    }
    
    func fetchPlaylists() {
        let p = PlaylistModel(name: "First Playlist", placeholder: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fru.wikipedia.org%2Fwiki%2F%25D0%25A4%25D0%25B0%25D0%25B9%25D0%25BB%3AHomer_Simpson.png&psig=AOvVaw0LuZmbDhsHfnAES2JfKO5N&ust=1586873322944000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCNifvvjJ5egCFQAAAAAdAAAAABAD", videos: [])
        playlists.append(p)
        playlists.append(p)
    }
}
