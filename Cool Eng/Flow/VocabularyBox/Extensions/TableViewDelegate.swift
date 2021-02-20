//
//  TableViewDelegate.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 05.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


//MARK: - UITableViewDelegate, UITableViewDataSource
extension VocabularyBoxViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleWords.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabulariesTableViewCell") as! VocabulariesTableViewCell
        
        let ind = indexPath.row
//        cell.isSelectedCell = selectedIndixies.contains(ind)
        
        let word = visibleWords[indexPath.row]
        cell.setup(word)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ind = indexPath.row
        if !selectedIndixies.contains(ind) {
            selectedIndixies.append(ind)
        } else {
            selectedIndixies.removeAll(where: { $0 == ind })
        }
        tableView.reloadData()
        reloadViews()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}
