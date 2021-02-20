//
//  VocabularyTableViewCell.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 20.02.2021.
//  Copyright © 2021 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import AVFoundation

class VocabularyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var originalWordLabel: UILabel!
    @IBOutlet weak var translatedWordLabel: UILabel!
    @IBOutlet weak var speachImageView: UIImageView!
    @IBOutlet weak var radiobuttonConstraint: NSLayoutConstraint!
    @IBOutlet weak var radioButtonView: RadioButton!
    
    private var wordText = ""
    
    func setup(_ word: Word, setSelected: Bool = false, isSelectable: Bool = false) {
        originalWordLabel.text = word.original
        var translation = word.translation
        if translation.contains(",") {
            let words = translation.components(separatedBy: ",")
            translation = "\(words[0]), \(words[1])"
        }
        translatedWordLabel.text = translation.trimmingCharacters(in: .whitespacesAndNewlines)
        wordText = word.original
        
        for i in speachImageView.gestureRecognizers ?? [] {
            speachImageView.removeGestureRecognizer(i)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(speachButtonAction))
        speachImageView.addGestureRecognizer(tap)
        
        if !isSelectable {
            radiobuttonConstraint.constant = 0
            radioButtonView.isHidden = true
        } else {
            radiobuttonConstraint.constant = 25
            radioButtonView.isHidden = false
        }
        radioButtonView.isOn = setSelected
    }
    
    
    @IBAction func speachButtonAction() {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: wordText)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
}
