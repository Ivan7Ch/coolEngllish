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
    
    @IBOutlet weak var viewsCountLabel: UILabel!
    
    @IBOutlet weak var videosCountLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        placeholder.layer.cornerRadius = 14
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
    }
    
    
    func configure(with playlistItem: PlaylistModel) {
        placeholder.image = UIImage(named: "default")
        if let url = URL(string: playlistItem.placeholder) {
            let image = UIImage(named: "default")
            placeholder.kf.setImage(with: url, placeholder: image)
        }
        placeholder.layer.borderWidth = 0.5
        placeholder.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.327739726)
        placeholder.layer.cornerRadius = 14
        
        nameLabel.text = playlistItem.name
        
        viewsCountLabel.text = "\(playlistItem.views) views"
        
        videosCountLabel.text = "\(playlistItem.videosCount) videos"
    }
}
