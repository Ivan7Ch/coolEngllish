//
//  StudyViewController.swift
//  WordsLearner
//
//  Created by Ivan Chernetskiy on 01.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


class StudyViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var readyButton: UIButton!
    
    var words = [Word]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setPastelBackground()

        if words.isEmpty {
            let w = DictionaryManager.shared.getWordsForStudy()
            words = []
            for i in 0..<6 {
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