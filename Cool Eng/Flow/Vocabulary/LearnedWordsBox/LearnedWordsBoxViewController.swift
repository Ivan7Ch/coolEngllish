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
    var words = [Word]()
    var visibleWords = [Word]()
    let wordsPackCount = 15
    var selectedIndixies = [Int]()
    
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


//MARK: - UITableViewDelegate, UITableViewDataSource
extension LearnedWordsBoxViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LearnedWordsBoxTableViewCell") as! VocabularyBoxTableViewCell
        
        let ind = indexPath.row
        cell.isSelectedCell = selectedIndixies.contains(ind)
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
        return UITableView.automaticDimension
    }
}

