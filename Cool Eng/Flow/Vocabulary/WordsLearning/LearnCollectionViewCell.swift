//
//  LearnCollectionViewCell.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 08.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import AVFoundation


class StudyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var originalWordLabel: UILabel!
    @IBOutlet weak var translationWordLabel: UILabel!
    @IBOutlet weak var transcriptionWordLabel: UILabel!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var word: Word?
    
    
    func setup(_ word: Word) {
        originalWordLabel.text = word.original
        
        translationWordLabel.text = word.translation
        //translationWordLabel.textColor = UIColor(named: "color4")
        
        transcriptionWordLabel.text = word.transcription
        //transcriptionWordLabel.textColor = UIColor(named: "color4")
        
        sentenceLabel.text = word.sentence
        
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = #colorLiteral(red: 0.09019607843, green: 0.08911801666, blue: 0.08911801666, alpha: 0.760354238)
        containerView.backgroundColor = UIColor(named: "learnCellContainer")
        
        self.word = word
    }
    
    
    @IBAction func playAudio() {
        guard let word = word else { return }
        
        speach(word.original)
    }

    
    private func speach(_ text: String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
}
