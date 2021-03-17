//
//  EmbededVocabularyViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.03.2021.
//  Copyright © 2021 Ivan Chernetskiy. All rights reserved.
//

import UIKit


class EmbededVocabularyViewController: UIViewController {
    
    @IBOutlet weak var wordsListView: VocabularyTableView!
    
    var ind: Int = 0
    var words = [Word]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordsListView.source = words  
        wordsListView.tableView.reloadData()
    }
}
