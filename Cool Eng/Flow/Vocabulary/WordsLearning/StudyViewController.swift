//
//  StudyViewController.swift
//  WordsLearner
//
//  Created by Ivan Chernetskiy on 01.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import Lottie


class StudyViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var readyButtonBottomConstraint: NSLayoutConstraint!
    
    var words = [Word]()
    
    var lottieView = AnimationView()
    
    var shouldShowHint = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setPastelBackground()
        
        if words.isEmpty {
            let w = DictionaryManager.shared.getWordsForStudy()
            var count = 6
            if w.count < 6 {
                count = w.count
            }
            words = []
            for i in 0..<count {
                words.append(w[i])
            }
        }
        
        setupViews()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    private func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = UIColor(named: "color1")
        
        setupReadyButton()
    }
    
    
    private func setupReadyButton() {
        readyButton.isUserInteractionEnabled = false
        readyButton.addTarget(self, action: #selector(readyButtonAction), for: .touchUpInside)
        readyButton.setTitleColor(.white, for: .normal)
        readyButton.layer.cornerRadius = 12
        readyButton.layer.borderWidth = 0.2
        
        readyButton.isUserInteractionEnabled = true
        readyButton.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        readyButton.layer.borderColor = #colorLiteral(red: 0.1912888479, green: 0.6130264327, blue: 0.927208915, alpha: 1)
        readyButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        readyButton.layer.shadowRadius = 8
        readyButton.layer.shadowOpacity = 0.3
        readyButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        readyButtonBottomConstraint.constant = -40 - 58
    }
    
    
    private func showReadyButton() {
        self.readyButtonBottomConstraint.constant = 40
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    private func showRightSwipe(containerView: UIView) {
        if !shouldShowHint { return }
        
        let jsonName = "rSwipe_White"
        let animation = Animation.named(jsonName)
        
        lottieView = AnimationView(animation: animation)
        lottieView.frame = CGRect(x: UIScreen.main.bounds.width - 150, y: (UIScreen.main.bounds.height / 2) - 100, width: 200, height: 200)
        view.addSubview(lottieView)
        lottieView.loopMode = .loop
        lottieView.isUserInteractionEnabled = false
        lottieView.play()
    }
    
    
    @IBAction func readyButtonAction() {
        if words.count < 6 { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Level1ViewController") as! Level1ViewController
        var vcWords = [Word]()
        
        for i in 0..<6 {
            vcWords.append(self.words[i])
        }
        vc.words = vcWords
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
        
        if indexPath.row == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showRightSwipe(containerView: self.view)
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= words.count - 1 {
            showReadyButton()
        }
        
        if indexPath.row >= 1 {
            lottieView.stop()
            shouldShowHint = false
        }
    }
}


extension StudyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}
