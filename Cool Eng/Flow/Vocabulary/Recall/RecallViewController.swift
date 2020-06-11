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
        containerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1255351027)
        correctLabel.text = ""
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
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        tabBarController?.tabBar.isHidden = true
        
        trueButton.addTarget(self, action: #selector(trueButtonAction), for: .touchUpInside)
        falseButton.addTarget(self, action: #selector(falseButtonAction), for: .touchUpInside)
        
        words = DictionaryManager.shared.getWordsForRecall()
        learnedWords = DictionaryManager.shared.getWordsForStudy()
        
        answers = Array(repeating: true, count: words.count)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        pastelView = PastelView(frame: view.bounds)
    }
    
    
    func checkIfCorrectAnswer(ans: Bool) {
        if currentIndex >= words.count { return }
        
        if answers[currentIndex] == ans {
            setPastelBackground(ans: true)
            currentIndex += 1
            if currentIndex >= words.count { return }
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .right, animated: true)
        } else {
            setPastelBackground(ans: false)
            if ans {
                let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as! RecallCollectionViewCell
                cell.correctLabel.text = words[currentIndex].translation
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                self.currentIndex += 1
                if self.currentIndex >= self.words.count { return }
                self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .right, animated: true)
            })
        }
    }
    
    
    @IBAction func trueButtonAction() {
        checkIfCorrectAnswer(ans: true)
    }
    
    
    @IBAction func falseButtonAction() {
        checkIfCorrectAnswer(ans: false)
    }
    
    func setPastelBackground(ans: Bool) {
        pastelView.removeFromSuperview()
        
        pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .top
        pastelView.endPastelPoint = .bottom
        pastelView.animationDuration = 5
        
        var colors = [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8904744485, green: 0.8502347224, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.6813562978, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.6451833526, alpha: 1)]
        
        if self.traitCollection.userInterfaceStyle == .dark {
            colors = [#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)]
        }
        
        if ans {
            colors = [#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)]
        } else {
            colors = [#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)]
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15 , execute: {
            self.pastelView.removeFromSuperview()
        })
        
        pastelView.setColors(colors)
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
}


extension RecallViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecallCollectionViewCell", for: indexPath) as! RecallCollectionViewCell
        
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
