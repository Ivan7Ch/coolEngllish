//
//  VocabulariesTableViewCell.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 05.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import AVFoundation


class VocabulariesTableViewCell: UITableViewCell {
    @IBOutlet weak var originalWordLabel: UILabel!
    @IBOutlet weak var translatedWordLabel: UILabel!
    @IBOutlet weak var speachImageView: UIImageView!
    
    private var wordText = ""
    
    
    func setup(_ word: Word) {
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
    }
    
    
    @IBAction func speachButtonAction() {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: wordText)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
}
