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
    
    @IBOutlet weak var addToVocabularyButton: UIButton!
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var selectedCountLabel: UILabel!
    @IBOutlet weak var selectAllLabel: UILabel!
    @IBOutlet weak var radioButton: UIImageView!
    @IBOutlet weak var wordsListView: VocabularyTableView!
    
    var completion: () -> Void = {}
    var words = [Word]()
    var visibleWords = [Word]()
    let wordsPackCount = 9999
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonContainer.layer.shadowColor = #colorLiteral(red: 0.1704200208, green: 0.5261289477, blue: 0.7275841832, alpha: 1)
        buttonContainer.layer.shadowRadius = 8
        buttonContainer.layer.shadowOpacity = 0.125
        
        reloadViews()
        prepareWords()
        
        addToVocabularyButton.addTarget(self, action: #selector(addToVocabularyButtonAction), for: .touchUpInside)
        
        wordsListView.isSelectable = true
        wordsListView.tableView.tableFooterView = createLoadMoreButton()
        wordsListView.didSelectHandler = {
            self.reloadViews()
        }
    }
    
    private func createLoadMoreButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(loadMoreWords), for: .touchUpInside)
        button.setTitle("Load more...", for: .normal)
        return button
    }
    
    
    private func prepareWords() {
        let wordsCount = wordsPackCount > words.count ? words.count : wordsPackCount
        
        for _ in 0..<wordsCount {
            visibleWords.append(words.first!)
            words.remove(at: 0)
        }
        wordsListView.source = visibleWords
        wordsListView.tableView.reloadData()
        reloadViews()
    }
    
    
    func reloadViews() {
        selectedCountLabel.text = "\(wordsListView.selectedIndices.count)/\(visibleWords.count)"
        if wordsListView.selectedIndices.isEmpty {
            addToVocabularyButton.setTitle("skip", for: .normal)
        } else {
            addToVocabularyButton.setTitle("Add To Vocabulary", for: .normal)
        }
        
        isSelectedAll = !(wordsListView.selectedIndices.count < visibleWords.count)
    }
    
    
    func addToVocabularyWords() {
        var dictIds = [Int]()
        var learnedIds = [Int]()
        
        for i in 0..<visibleWords.count {
            if wordsListView.selectedIndices.contains(i) {
                dictIds.append(visibleWords[i].id)
            } else {
                learnedIds.append(visibleWords[i].id)
            }
        }
        
        DictionaryManager.shared.addToDictionary(ids: dictIds)
        DictionaryManager.shared.markAsLearned(ids: learnedIds)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        completion()
    }
}


//MARK: - Actions
extension VocabularyBoxViewController {
    @IBAction func radioButtonAction() {
        isSelectedAll.toggle()
        wordsListView.selectedIndices = []
        
        var selectAllLabelText = "select all"
        if isSelectedAll {
            for i in 0..<visibleWords.count {
                wordsListView.selectedIndices.append(i)
            }
            selectAllLabelText = "deselect all"
        }
        selectAllLabel.text = selectAllLabelText
        wordsListView.tableView.reloadData()
        reloadViews()
    }
    
    @IBAction func loadMoreWords() {
        var c = 0
        for word in words {
            visibleWords.append(word)
            c += 1
            if c == wordsPackCount { break }
        }
        
        if c < wordsPackCount {
            loadMoreButton.setTitle("", for: .normal)
        }
        
        for _ in 0..<c {
            words.remove(at: 0)
        }
        
        wordsListView.tableView.reloadData()
        reloadViews()
    }
    
    @IBAction func addToVocabularyButtonAction() {
        addToVocabularyWords()
        self.dismiss(animated: true, completion: nil)
    }
}
