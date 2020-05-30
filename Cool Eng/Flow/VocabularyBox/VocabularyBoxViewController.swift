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
    
    @IBOutlet weak var addToVocabularyButton: UIButton!
    
    @IBOutlet weak var buttonContainer: UIView!
    
    @IBOutlet weak var selectedCountLabel: UILabel!
    
    @IBOutlet weak var selectAllLabel: UILabel!
    
    @IBOutlet weak var radioButton: UIImageView!
    
    var isSelectedAll: Bool = false {
        didSet {
            if isSelectedAll {
                radioButton.image = UIImage(named: "radiobutton")
            } else {
                radioButton.image = UIImage(named: "rbempty")
            }
        }
    }
    
    
    var allWords = [Word]()
    
    var words = [Word]()
    
    var selectedIndixies = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        buttonContainer.layer.shadowColor = #colorLiteral(red: 0.1704200208, green: 0.5261289477, blue: 0.7275841832, alpha: 1)
        buttonContainer.layer.shadowRadius = 8
        buttonContainer.layer.shadowOpacity = 0.125
        
        reloadViews()
        prepareWords()
        
        addToVocabularyButton.addTarget(self, action: #selector(addToVocabularyButtonAction), for: .touchUpInside)
    }
    
    
    @IBAction func radioButtonAction() {
        isSelectedAll.toggle()
        selectedIndixies = []
        
        var selectAllLabelText = "select all"
        if isSelectedAll {
            for i in 0..<words.count {
                selectedIndixies.append(i)
            }
            selectAllLabelText = "deselect all"
        }
        selectAllLabel.text = selectAllLabelText
        tableView.reloadData()
        reloadViews()
    }
    
    
    @IBAction func loadMoreWords() {
        var c = 0
        for (i, word) in allWords.enumerated() {
            words.append(allWords[i])
            allWords.remove(at: i)
            c += 1
            if c == 15 { break }
        }
        
        tableView.reloadData()
        reloadViews()
    }
    
    
    private func prepareWords() {
        allWords = words
        words = []
        
        if allWords.count < 15 {
            for i in allWords {
                words.append(i)
            }
            return
        }
        
        for i in 0..<15 {
            words.append(allWords[i])
            allWords.remove(at: i)
        }
        tableView.reloadData()
        reloadViews()
    }
    
    
    private func reloadViews() {
        selectedCountLabel.text = "\(selectedIndixies.count)/\(words.count)"
        if selectedIndixies.isEmpty {
            addToVocabularyButton.setTitle("skip", for: .normal)
        } else {
            addToVocabularyButton.setTitle("Add To Vocabulary", for: .normal)
        }
    }
    
    
    @IBAction func addToVocabularyButtonAction() {
        addToVocabularyWords()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func addToVocabularyWords() {
        var dictIds = [Int]()
        var learnedIds = [Int]()
        
        for i in 0..<words.count {
            if selectedIndixies.contains(i) {
                dictIds.append(words[i].id)
            } else {
                learnedIds.append(words[i].id)
            }
        }
        
        DictionaryManager.shared.addToDictionary(ids: dictIds)
        DictionaryManager.shared.markAsLearned(ids: learnedIds)
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
        reloadViews()
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
