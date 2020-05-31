//
//  Level3ViewController.swift
//  WordsLearner
//
//  Created by Ivan Chernetskiy on 03.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class Level3CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var letterLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
}


class Level3ViewController: UIViewController {
    
    @IBOutlet weak var mainWordLabel: UILabel!
    @IBOutlet weak var translationWordLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var words = [Word]()
    var letters = [String]()
    
    var currentIndex = 0
    var mainWord = "" {
        didSet {
            mainWordLabel.text = mainWord
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        reloadViews()
        self.setPastelBackground()
    }
    
    private func nextStep() {
        // TODO: - set words progress
        navigationController?.popToRootViewController(animated: true)
    }
    
    func reloadViews() {
        let word = Array(words[currentIndex].original)
        mainWord = ""
        letters = []
        for i in word {
            letters.append("\(i)")
        }
        letters.shuffle()
        
        translationWordLabel.text = words[currentIndex].translation
        
        collectionView.reloadData()
    }
}


extension Level3ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Level3CollectionViewCell", for: indexPath) as! Level3CollectionViewCell
        
        cell.letterLabel.text = letters[indexPath.row].lowercased()
        cell.containerView.layer.cornerRadius = 4
        cell.isUserInteractionEnabled = true
        cell.containerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.letterLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        print(letters[indexPath.row].lowercased())
        return cell
    }
    
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = 45
        let cellSpacing: CGFloat = 6
        
        var count = CGFloat(words[currentIndex].original.count)
        if indexPath.row < 7 {
            if count > 7 {
                count = 7
            }
            let width = (collectionView.bounds.size.width - ((count - 1) * cellSpacing)) / count
            return CGSize(width: width, height: cellHeight)
        }
        
        if indexPath.row >= 7 {
            count = count - 7
            let width = (collectionView.bounds.size.width - 2) / count
            return CGSize(width: width, height: cellHeight)
        }
        let width = (collectionView.bounds.size.width - ((count - 1) * cellSpacing)) / count
        return CGSize(width: width, height: cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! Level3CollectionViewCell
        
        let correctLetter = Array(words[currentIndex].original)[mainWord.count]
        
        if letters[indexPath.row] == "\(correctLetter)" {
            cell.letterLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            UIView.animate(withDuration: 0.5, animations: {
                cell.containerView.layer.borderWidth = 0.5
                cell.containerView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                cell.containerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            })
            cell.isUserInteractionEnabled = false
            let character = letters[indexPath.row]
            mainWord = "\(mainWord)\(character)"
            
            if words[currentIndex].original.lowercased() == mainWord.lowercased() {
                currentIndex += 1
                if words.count == currentIndex {
                    nextStep()
                } else {
                    reloadViews()
                }
            }
        } else {
            cell.containerView.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            
            UIView.animate(withDuration: 0.5, animations: {
                cell.containerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            })
        }
    }
}
