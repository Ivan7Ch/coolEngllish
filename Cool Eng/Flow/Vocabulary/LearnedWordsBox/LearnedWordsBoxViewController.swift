//
//  LearnedBoxViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 08.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


class LearnedWordsBoxViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addToVocabularyButton: UIButton!
    
    @IBOutlet weak var buttonContainer: UIView!
    
    @IBOutlet weak var selectedCountLabel: UILabel!
    
    @IBOutlet weak var selectAllLabel: UILabel!
    
    @IBOutlet weak var radioButton: UIImageView!
    
    var isSelectedAll: Bool = false {
        didSet {
            if isSelectedAll {
                selectAllLabel.text = "deselect all"
                radioButton.image = UIImage(named: "radiobutton")
            } else {
                selectAllLabel.text = "select all"
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
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        for i in 0..<words.count {
            selectedIndixies.append(i)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 89
        
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
            addToVocabularyButton.setTitle("Add to Recall List", for: .normal)
        }
        
        isSelectedAll = !(selectedIndixies.count < visibleWords.count)
    }
    
    
    func addToRecallBox() {
        var recallIds = [Int]()
        
        for i in 0..<visibleWords.count {
            if selectedIndixies.contains(i) {
                recallIds.append(visibleWords[i].id)
            }
        }
        
        DictionaryManager.shared.addToRecallList(ids: recallIds)
    }
}
