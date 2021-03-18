//
//  VocabularyTableView.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 20.02.2021.
//  Copyright © 2021 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class VocabularyTableView: UIView {
    
    let tableView = UITableView()
    var isSelectable: Bool = false
    var source = [Word]()
    var selectedIndices = [Int]()
    var didSelectHandler: (() -> Void) = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTableView()
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: "VocabularyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VocabularyTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension VocabularyTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyTableViewCell", for: indexPath) as! VocabularyTableViewCell
        
        let word = source[indexPath.row]
        if isSelectable {
            cell.setup(word, setSelected: selectedIndices.contains(indexPath.row), isSelectable: true)
        } else {
            cell.setup(word)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let ind = selectedIndices.firstIndex(of: indexPath.row) {
            selectedIndices.remove(at: ind)
        } else {
            selectedIndices.append(indexPath.row)
        }
        tableView.reloadData()
        didSelectHandler()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
}

