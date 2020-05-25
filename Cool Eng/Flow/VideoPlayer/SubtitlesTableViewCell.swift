//
//  SubtitleTableViewCell.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 24.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import ActiveLabel

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
        originalText.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        originalText.hashtagColor = #colorLiteral(red: 0.1411764706, green: 0.4470588235, blue: 0.6705882353, alpha: 1)
        originalText.handleHashtagTap {
            self.wordTapHandler($0)
        }
    }
    
    
    @IBAction func seekVideoPositionButtonAction() {
        cellTapHandler(index)
        print(index)
    }
}
