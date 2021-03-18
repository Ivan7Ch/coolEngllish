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
    
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var selectedCountLabel: UILabel!
    @IBOutlet weak var selectAllLabel: UILabel!
    @IBOutlet weak var radioButton: UIImageView!
    @IBOutlet weak var wordsListView: VocabularyTableView!
    
    var dissmisCompletion: () -> Void = {}
    var mainButtonActionClosure: (() -> Void)?
    var words = [Word]()
    var visibleWords = [Word]()
    let wordsPackCount = 9999
    var mainButtonName: String?
    
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
        
        mainButton.addTarget(self, action: #selector(addToVocabularyButtonAction), for: .touchUpInside)
        
        wordsListView.isSelectable = true
        wordsListView.tableView.tableFooterView = UIView()
        wordsListView.didSelectHandler = {
            self.reloadViews()
        }
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
        if let name = mainButtonName {
            mainButton.setTitle(name, for: .normal)
        } else {
            mainButton.setTitle("Add To Vocabulary", for: .normal)
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
        
        dissmisCompletion()
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
    
    @IBAction func addToVocabularyButtonAction() {
        if let completion = mainButtonActionClosure {
            completion()
        } else {
            addToVocabularyWords()
        }
        self.dismiss(animated: true, completion: {
            self.dissmisCompletion()
        })
    }
}
