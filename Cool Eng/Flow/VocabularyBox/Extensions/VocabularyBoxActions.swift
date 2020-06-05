//
//  VocabularyBoxActions.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 05.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


//MARK: - Actions
extension VocabularyBoxViewController {
    
    @IBAction func radioButtonAction() {
        isSelectedAll.toggle()
        selectedIndixies = []
        
        var selectAllLabelText = "select all"
        if isSelectedAll {
            for i in 0..<visibleWords.count {
                selectedIndixies.append(i)
            }
            selectAllLabelText = "deselect all"
        }
        selectAllLabel.text = selectAllLabelText
        tableView.reloadData()
        reloadViews()
    }
    
    
    @IBAction func loadMoreWords() {
        var c = 0
        for word in words {
            visibleWords.append(word)
            c += 1
            if c == wordsPackCount { break }
        }
        
        for _ in 0..<c {
            words.remove(at: 0)
        }
        
        tableView.reloadData()
        reloadViews()
    }
    
    
    @IBAction func addToVocabularyButtonAction() {
        addToVocabularyWords()
        self.dismiss(animated: true, completion: nil)
    }
}
