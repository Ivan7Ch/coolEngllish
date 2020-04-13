//
//  PlaylistTableViewCell.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


class PlaylistTableViewCell: UITableViewCell {
    static let reuseIdentifer = "playlist-cell"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var placeholder: UIImageView!
    
    
    func configure(with playlistItem: PlaylistModel) {
        placeholder.image = UIImage(named: "default")
        if let url = URL(string: playlistItem.placeholder) {
            placeholder.load(url: url)
        }
        
        nameLabel.text = playlistItem.name
    }
}
