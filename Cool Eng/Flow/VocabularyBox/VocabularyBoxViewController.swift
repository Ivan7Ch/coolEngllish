//
//  VocabularyBoxViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 25.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import AVFoundation


class VocabularyBoxViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var watchButton: UIButton!
    
    @IBOutlet weak var buttonContainer: UIView!
    
    var words = [Word]()
    var selectedIndixies = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        buttonContainer.layer.shadowColor = #colorLiteral(red: 0.1704200208, green: 0.5261289477, blue: 0.7275841832, alpha: 1)
        buttonContainer.layer.shadowRadius = 8
        buttonContainer.layer.shadowOpacity = 0.125
    }
}


extension VocabularyBoxViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyBoxTableViewCell") as! VocabularyBoxTableViewCell
        
        let ind = indexPath.row
        cell.isSelectedCell = selectedIndixies.contains(ind)
        
        let word = words[indexPath.row]
        cell.setup(word)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ind = indexPath.row
        if !selectedIndixies.contains(ind) {
            selectedIndixies.append(ind)
        } else {
            selectedIndixies.removeAll(where: { $0 == ind })
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}


class VocabularyBoxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var originalWord: UILabel!
    @IBOutlet weak var translatedWord: UILabel!
    @IBOutlet weak var speachButton: UIButton!
    @IBOutlet weak var selectionIndicator: UIImageView!
    
    private var wordText = ""
    
    var isSelectedCell: Bool = false {
        didSet {
            if isSelectedCell {
                selectionIndicator.image = UIImage(named: "radiobutton")
            } else {
                selectionIndicator.image = UIImage(named: "rbempty")
            }
        }
    }
    
    func setup(_ word: Word) {
        originalWord.text = word.original
        translatedWord.text = word.translation
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
