//
//  SubtitleTableViewCell.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 24.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class SubtitlesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var originalText: ActiveLabel!
    @IBOutlet weak var translatedText: UILabel!
    @IBOutlet weak var indicator: UIView!
    
    var wordTapHandler: (String) -> () = {_ in }
    var cellTapHandler: (Int) -> () = {_ in }
    var index: Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        setupActiveLabel()
    }
    
    
    private func setupActiveLabel() {
        originalText.numberOfLines = 0
        originalText.textColor = UIColor(named: "subtitleLabel")
        originalText.hashtagColor = UIColor(named: "subtitleLabel")!
        originalText.handleHashtagTap {
            self.wordTapHandler($0)
        }
    }
    
    
    @IBAction func seekVideoPositionButtonAction() {
        cellTapHandler(index)
    }
}
