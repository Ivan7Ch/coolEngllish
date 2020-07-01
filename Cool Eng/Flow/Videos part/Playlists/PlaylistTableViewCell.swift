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
    
    @IBOutlet weak var effectView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        effectView.layer.cornerRadius = 16
        effectView.clipsToBounds = true
    }
    
    
    func configure(with playlistItem: PlaylistModel) {
        placeholder.image = UIImage(named: "default")
        if let url = URL(string: playlistItem.placeholder) {
            let image = UIImage(named: "default")
            placeholder.kf.setImage(with: url, placeholder: image, completionHandler: { _ in
                var color = (self.placeholder.image?.averageColor)!
                color = color.withAlphaComponent(0.85)
                self.viewsCountLabel.backgroundColor = color
                self.viewsCountLabel.textColor = color.isDarkColor ? .white : .black
                
                self.videosCountLabel.backgroundColor = color
                self.videosCountLabel.textColor = color.isDarkColor ? .white : .black
            })
        }
        placeholder.layer.borderWidth = 0.5
        placeholder.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.327739726)
        placeholder.layer.cornerRadius = 16
        
        nameLabel.text = playlistItem.name
        
        viewsCountLabel.layer.masksToBounds = true
        viewsCountLabel.text = "\(playlistItem.views) views"
        
        videosCountLabel.layer.masksToBounds = true
        videosCountLabel.text = "\(playlistItem.videosCount) videos"
        videosCountLabel.layer.cornerRadius = 8
        videosCountLabel.layer.maskedCorners = [.layerMinXMinYCorner]
    }
}
