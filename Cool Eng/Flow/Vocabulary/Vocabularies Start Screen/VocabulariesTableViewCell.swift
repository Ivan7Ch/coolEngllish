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
    @IBOutlet weak var originalWord: UILabel!
    @IBOutlet weak var translatedWord: UILabel!
    @IBOutlet weak var speachButton: UIButton!
    
    private var wordText = ""
    
    
    func setup(_ word: Word) {
        originalWord.text = word.original
        var translation = word.translation
        if translation.contains(",") {
            let words = translation.components(separatedBy: ",")
            translation = "\(words[0]), \(words[1])"
        }
        translatedWord.text = translation
        wordText = word.original
    }
    
    
    @IBAction func speachButtonAction() {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: wordText)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
}
