//
//  Level1ViewController.swift
//  WordsLearner
//
//  Created by Ivan Chernetskiy on 01.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


class Level1TableViewCell: UITableViewCell {
    
    @IBOutlet weak var wordLabel: UILabel!
    
    func setup(with text: String) {
        wordLabel.text = text
    }
}


class Level1ViewController: UIViewController {
    
    enum StudyState {
        case original, translation
    }


    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mainWordLabel: UILabel!
    
    @IBOutlet weak var mainWordContainer: UIView!
    
    
    var words = [Word]()
    
    var currentIndex = 0
    
    var state: StudyState = .original
    
    var tableWords = [Word]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        reloadViews(with: 0)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    @IBAction func skipButtonAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    private func setupViews() {
        tableView.layer.cornerRadius = 8
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.layer.shadowRadius = 4
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowOffset = CGSize(width: 0, height: 1)
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor(named: "color4")?.cgColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        mainWordContainer.layer.cornerRadius = 8
        mainWordContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainWordContainer.backgroundColor = UIColor(named: "color5")
    }
    
    
    private func reloadViews(with index: Int) {
        if state == .original {
            mainWordLabel.text = words[index].translation
        } else {
            mainWordLabel.text = words[index].original
        }
        setTableWords()
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
    
    
    private func rightSelection() {
        currentIndex += 1
        if currentIndex < words.count, state == .original {
            reloadViews(with: currentIndex)
        } else {
            if state == .original {
                state = .translation
                currentIndex = 0
                reloadViews(with: currentIndex)
            }
        }
        
        if currentIndex >= words.count, state == .translation {
            showNext()
        } else {
            reloadViews(with: currentIndex)
        }
    }
    
    
    private func showNext() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Level2ViewController") as! Level2ViewController
        vc.words = self.words
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension Level1ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableWords.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Level1TableViewCell", for: indexPath) as! Level1TableViewCell
        cell.selectionStyle = .none
        
        let word = tableWords[indexPath.row]
        if state == .original {
            cell.setup(with: word.original)
        } else {
            cell.setup(with: word.translation)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.bounds.size.height / 4
        return height
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentIndex >= words.count { return }
        
        let delay = 0.8
        let selectedWord = tableWords[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
        
        if selectedWord.original == words[currentIndex].original {
            cell?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.rightSelection()
            })
        } else {
            cell?.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 0.7858251284)
        }
        
        UIView.animate(withDuration: delay, animations: {
            cell?.backgroundColor = .systemBackground
        })
    }
}
