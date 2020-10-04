//
//  AddNewWordsViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 10.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import Pastel


class AddNewWordsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var originalWordLabel: UILabel!
    @IBOutlet weak var transcriptionLabel: UILabel!
    @IBOutlet weak var translationWordLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var correctLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 16
        correctLabel.text = ""
        originalWordLabel.textColor = UIColor(named: "negativeLabel")
        translationWordLabel.textColor = UIColor(named: "negativeLabel")
    }
}



class AddNewWordsViewController_: UIViewController {
    
    var pastelView: PastelView!
    
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var words = [Word]()
    
    var learnedWords = [Word]()
    
    var currentIndex = 0
    
    var answers = [Bool]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        tabBarController?.tabBar.isHidden = true
        
        trueButton.addTarget(self, action: #selector(trueButtonAction), for: .touchUpInside)
        falseButton.addTarget(self, action: #selector(falseButtonAction), for: .touchUpInside)
        
        words = getWords().shuffled()
        
        learnedWords = DictionaryManager.shared.getRandWords()
        
        answers = Array(repeating: true, count: words.count)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        navigationController?.isNavigationBarHidden = true
        
        setupButton(falseButton)
        setupButton(trueButton)
        
        setPastelBackground()
    }
    
    
    func setupButton(_ button: UIButton) {
        button.backgroundColor = UIColor(named: "learnCellContainer")
        button.layer.cornerRadius = 12
        button.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 0.2
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8075502997)
        button.layer.borderWidth = 0.5
        button.setTitleColor(UIColor(named: "subtitleLabel"), for: .normal)
    }
    
    
    @IBAction func skipButtonAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    func checkIfCorrectAnswer(ans: Bool) {
        if currentIndex >= words.count {
            navigationController?.popToRootViewController(animated: true)
        }
        guard let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? AddNewWordsCollectionViewCell else { return }
        
        var delay = 0.0
        
        if answers[currentIndex] == ans {
            cell.containerView.backgroundColor = UIColor(named: "correctAnswer")
        } else {
            cell.containerView.backgroundColor = UIColor(named: "incorrectAnswer")
            if ans {
                var translation = words[currentIndex].translation
                if translation.contains(",") {
                    let words = translation.components(separatedBy: ",")
                    translation = "\(words[0]), \(words[1])"
                }
                cell.correctLabel.text = translation
            }
            DictionaryManager.shared.addToDictionary(ids: [words[currentIndex].id])
            delay = 0.8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.currentIndex += 1
            if self.currentIndex >= self.words.count {
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .right, animated: true)
        })
    }
    
    
    @IBAction func trueButtonAction() {
        checkIfCorrectAnswer(ans: true)
    }
    
    
    @IBAction func falseButtonAction() {
        checkIfCorrectAnswer(ans: false)
    }
    
    private func getWords() -> [Word] {
        let level = UserDefaults.standard.integer(forKey: "englishLevel")
        
        for i in EnglishLevel.allCases {
            if i.rawValue == level {
                let words = DictionaryManager.shared.getWordsFor(level: i)
                return words
            }
        }
        
        return []
    }
}


extension AddNewWordsViewController_: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNewWordsCollectionViewCell", for: indexPath) as! AddNewWordsCollectionViewCell
        
        cell.containerView.backgroundColor = UIColor(named: "recallCellColor")
        
        let word = words[indexPath.row]
        var translation = word.translation
        if Bool.random() {
            let ind = Int.random(in: 0..<learnedWords.count)
            translation = learnedWords[ind].translation
            answers[indexPath.row] = false
        }
        
        cell.originalWordLabel.text = word.original
        cell.transcriptionLabel.text = word.transcription
        cell.translationWordLabel.text = translation
        cell.correctLabel.text = ""
        
        return cell
    }
    
}

extension AddNewWordsViewController_: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}
