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
    
    
    var words = [Word]()
    
    var visibleWords = [Word]()
    
    let wordsPackCount = 15
    
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
    
    
    private func prepareWords() {
        
        let wordsCount = wordsPackCount > words.count ? words.count : wordsPackCount
        
        for _ in 0..<wordsCount {
            visibleWords.append(words.first!)
            words.remove(at: 0)
        }
        
        tableView.reloadData()
        reloadViews()
    }
    
    
    func reloadViews() {
        selectedCountLabel.text = "\(selectedIndixies.count)/\(visibleWords.count)"
        if selectedIndixies.isEmpty {
            addToVocabularyButton.setTitle("skip", for: .normal)
        } else {
            addToVocabularyButton.setTitle("Add To Vocabulary", for: .normal)
        }
    }
    
    
    func addToVocabularyWords() {
        var dictIds = [Int]()
        var learnedIds = [Int]()
        
        for i in 0..<visibleWords.count {
            if selectedIndixies.contains(i) {
                dictIds.append(visibleWords[i].id)
            } else {
                learnedIds.append(visibleWords[i].id)
            }
        }
        
        DictionaryManager.shared.addToDictionary(ids: dictIds)
        DictionaryManager.shared.markAsLearned(ids: learnedIds)
    }
}
