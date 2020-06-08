//
//  LearnedWordsBoxActionsExxtension.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 08.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


//MARK: - Actions
extension LearnedWordsBoxViewController {
    
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
    
    
    @IBAction func addToVocabularyButtonAction() {
        addToRecallBox()
        self.navigationController?.popToRootViewController(animated: true)
    }
}
