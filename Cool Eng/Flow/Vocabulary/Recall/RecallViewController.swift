//
//  RecallViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 10.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import Pastel


class RecallCollectionViewCell: UICollectionViewCell {
    
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



class RecallViewController: UIViewController {
    
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
        
        tabBarController?.tabBar.isHidden = true
        
        trueButton.addTarget(self, action: #selector(trueButtonAction), for: .touchUpInside)
        falseButton.addTarget(self, action: #selector(falseButtonAction), for: .touchUpInside)
        
        words = DictionaryManager.shared.getWordsForRecall()
        learnedWords = DictionaryManager.shared.getRandWords()
        
        answers = Array(repeating: true, count: words.count)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        navigationController?.isNavigationBarHidden = true
        
        setupButton(falseButton)
        setupButton(trueButton)
        
        setPastelBackground()
    }
    
    
    func setupButton(_ button: UIButton) {
        button.backgroundColor = UIColor(named: "learnCellContainer")
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor(named: "recallCellColor")?.cgColor
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 0.2
        button.layer.borderColor = UIColor(named: "recallCellColor")?.cgColor
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
        guard let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? RecallCollectionViewCell else { return }
        
        var delay = 0.0
        
        if answers[currentIndex] == ans {
            cell.containerView.backgroundColor = UIColor(named: "correctAnswer")
            DictionaryManager.shared.markAsLearned(ids: [words[currentIndex].id])
        } else {
            cell.containerView.backgroundColor = UIColor(named: "incorrectAnswer")
            if ans {
                cell.correctLabel.text = words[currentIndex].translation
            }
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
}


extension RecallViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecallCollectionViewCell", for: indexPath) as! RecallCollectionViewCell
        
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

extension RecallViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}
