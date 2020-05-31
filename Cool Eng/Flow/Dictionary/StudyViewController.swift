//
//  StudyViewController.swift
//  WordsLearner
//
//  Created by Ivan Chernetskiy on 01.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import Pastel
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


class StudyViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var readyButton: UIButton!
    
    var words = [Word]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(false, forKey: "isPlaying")
        
        self.setPastelBackground()

        words = DictionaryManager.shared.getWordsForStudy()
        
        setupViews()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    private func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = UIColor(named: "color1")
        
        readyButton.addTarget(self, action: #selector(readyButtonAction), for: .touchUpInside)
        readyButton.setTitleColor(.white, for: .normal)
        readyButton.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        readyButton.layer.cornerRadius = 12
        readyButton.layer.borderWidth = 0.2
        readyButton.layer.borderColor = #colorLiteral(red: 0.1411764706, green: 0.4470588235, blue: 0.6705882353, alpha: 1)
        readyButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        readyButton.layer.shadowRadius = 8
        readyButton.layer.shadowOpacity = 0.3
        readyButton.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    
    @IBAction func readyButtonAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Level2ViewController") as! Level2ViewController
        vc.words = self.words
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension StudyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudyCollectionViewCell", for: indexPath) as! StudyCollectionViewCell
        let word = words[indexPath.row]
        cell.setup(word)
        return cell
    }
}


extension StudyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}


extension UIViewController {
    func setPastelBackground() {
        let pastelView = PastelView(frame: view.bounds)

        pastelView.startPastelPoint = .top
        pastelView.endPastelPoint = .bottom
        pastelView.animationDuration = 7.0
            
        var colors = [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8904744485, green: 0.8502347224, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.6813562978, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.6451833526, alpha: 1)]
        
        if self.traitCollection.userInterfaceStyle == .dark {
            colors = [#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1058823529, green: 0.1490196078, blue: 0.1725490196, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)]
        }
        
        pastelView.setColors(colors)
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
}
