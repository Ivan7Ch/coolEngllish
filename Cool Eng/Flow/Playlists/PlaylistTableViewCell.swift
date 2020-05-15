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
    
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lock: UIImageView!
    
    @IBOutlet weak var lockWidth: NSLayoutConstraint!
    
    @IBOutlet weak var viewsCountLabel: UILabel!
    
    
    func configure(with playlistItem: PlaylistModel) {
        activitiIndicator.stopAnimating()
        placeholder.image = UIImage(named: "default")
        if let url = URL(string: playlistItem.placeholder) {
            placeholder.load(url: url)
        }
        placeholder.layer.cornerRadius = 8
        
        nameLabel.text = playlistItem.name
        
        if PlaylistsCacheHelper.shared.getPlaylistsId().contains("\(playlistItem.id)") {
            lock.alpha = 0
            lockWidth.constant = 0
        } else {
            lock.alpha = 1
            lockWidth.constant = 46
        }
        
        lock.alpha = 0
        lockWidth.constant = 0
        
        viewsCountLabel.text = "\(playlistItem.views) views"
    }
}
