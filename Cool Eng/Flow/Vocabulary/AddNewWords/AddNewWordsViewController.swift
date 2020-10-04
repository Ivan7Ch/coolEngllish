//
//  AddNewWordsViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 20.08.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


class AddNewWordsViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mainWordLabel: UILabel!
    
    @IBOutlet weak var mainWordContainer: UIView!
    
    
    var words = [Word]()
    
    var currentIndex = 0
    
    var tableWords = [Word]()
    
    var level = EnglishLevel.advanced
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        words = DictionaryManager.shared.getWordsFor(level: level)
        
        setupViews()
        reloadViews(with: 0)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.setPastelBackground()
    }
    
    
    private func setTableWords() {
        tableWords = []
        var shuffledWords = words.shuffled()
        shuffledWords.removeAll(where: { return $0.original == self.words[currentIndex].original })
        for i in 0..<4 {
            tableWords.append(shuffledWords[i])
        }
        let word = words[currentIndex]
        let wordInd = Int.random(in: 0..<4)
        tableWords[wordInd] = word
        tableView.reloadData()
    }
    
    
    private func reloadViews(with index: Int) {
        if words.isEmpty || index > words.count { return }
        
        let word = words[index]
        
        
        mainWordLabel.text = word.original
        setTableWords()
    }
    
    
    
    private func correctSelection() {
        currentIndex += 1
        
        if currentIndex >= words.count {
            showNext()
        } else {
            reloadViews(with: currentIndex)
        }
    }
    
    
    private func showNext() {
        navigationController?.popToRootViewController(animated: true)
    }
}


extension AddNewWordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableWords.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Level1TableViewCell", for: indexPath) as! Level1TableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "learnCellContainer")
        
        let word = tableWords[indexPath.row]
        var translation = word.translation
        if translation.contains(",") {
            let words = translation.components(separatedBy: ",")
            translation = "\(words[0]), \(words[1])"
        }
        cell.setup(with: translation)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.bounds.size.height / 4
        return height
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentIndex >= words.count { return }
        
        let delay = 0.6
        let selectedWord = tableWords[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
        
        if selectedWord.original == words[currentIndex].original {
            DictionaryManager.shared.markAsLearned(ids: [words[currentIndex].id])
            UIView.animate(withDuration: 0.18, animations: {
                cell?.backgroundColor = UIColor(named: "correctAnswer")
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.28, execute: {
                UIView.animate(withDuration: 0.12, animations: {
                    cell?.backgroundColor = UIColor(named: "learnCellContainer")
                })
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.correctSelection()
            })
        } else {
            DictionaryManager.shared.addToDictionary(ids: [words[currentIndex].id])
            cell?.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 0.7858251284)
            UIView.animate(withDuration: delay, animations: {
                cell?.backgroundColor = UIColor(named: "learnCellContainer")
            })
        }
    }
}


// MARK:- View settup
extension AddNewWordsViewController {
    private func setupViews() {
        tableView.layer.cornerRadius = 12
        tableView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.layer.shadowRadius = 4
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowOffset = CGSize(width: 0, height: 1)
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        mainWordContainer.layer.cornerRadius = 8
        mainWordContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainWordContainer.backgroundColor = UIColor(named: "color5")
        
        tabBarController?.tabBar.isHidden = true
    }
}


// MARK:- IBactions
extension AddNewWordsViewController {
    @IBAction func skipButtonAction() {
        navigationController?.popToRootViewController(animated: true)
    }
}

