//
//  Level2ViewController.swift
//  WordsLearner
//
//  Created by Ivan Chernetskiy on 02.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class Level2TableViewCell: UITableViewCell {
    
    @IBOutlet weak var wordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 1)
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        selectedBackgroundView = backgroundView
    }
    
    func setup(with text: String) {
        wordLabel.text = text
    }
}


class Level2ViewController: UIViewController {

    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    @IBOutlet weak var underView: UIView!
    
    var words = [Word]()
    
    var rightWords = [String]()
    
    var leftIndex = -1
    var rightIndex = -1
    
    var guessedWordsCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        underView.clipsToBounds = false
        underView.layer.cornerRadius = 8
        underView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        underView.layer.shadowRadius = 8
        underView.layer.shadowOpacity = 0.5
        underView.layer.shadowOffset = CGSize(width: 0, height: 0)
        underView.backgroundColor = UIColor(named: "learnCellContainer")
        
        leftTableView.layer.cornerRadius = 8
        leftTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        rightTableView.layer.cornerRadius = 8
        rightTableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        leftTableView.delegate = self
        rightTableView.delegate = self
        
        leftTableView.dataSource = self
        rightTableView.dataSource = self
        
        setupWords()
        self.setPastelBackground()
    }
    
    private func setupWords() {
        for i in words {
            rightWords.append(i.translation)
        }
        words.shuffle()
        rightWords.shuffle()
    }
    
    private func nextStep() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Level3ViewController") as! Level3ViewController
        vc.words = self.words
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func skipButtonAction() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension Level2ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Level2TableViewCellLeft", for: indexPath) as! Level2TableViewCell
            cell.setup(with: words[indexPath.row].original)
            return cell
        }
        
        if tableView == rightTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Level2TableViewCellRight", for: indexPath) as! Level2TableViewCell
            cell.setup(with: rightWords[indexPath.row])
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.bounds.height / CGFloat(words.count)
        return height
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == leftTableView {
            leftIndex = indexPath.row
        } else {
            rightIndex = indexPath.row
        }
        
        let leftCell = leftTableView.cellForRow(at: IndexPath.init(item: leftIndex, section: 0))
        let rightCell = rightTableView.cellForRow(at: IndexPath.init(item: rightIndex, section: 0))
        
        if leftIndex < 0 || rightIndex < 0 { return }
        
        if words[leftIndex].translation == rightWords[rightIndex] {
            leftCell?.backgroundColor = UIColor(named: "color5")
            rightCell?.backgroundColor = UIColor(named: "color5")
            
            self.leftTableView.deselectRow(at: IndexPath.init(item: self.leftIndex, section: 0), animated: true)
            self.rightTableView.deselectRow(at: IndexPath.init(item: self.rightIndex, section: 0), animated: true)
            
            UIView.animate(withDuration: 1, animations: {
                leftCell?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.4962007705)
                rightCell?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.4962007705)
            })
            
            leftCell?.isUserInteractionEnabled = false
            rightCell?.isUserInteractionEnabled = false
            
            guessedWordsCount += 1
            if guessedWordsCount == words.count {
                nextStep()
            }
        } else {
            leftCell?.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 0.8478167809)
            rightCell?.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 0.8478167809)
            
            UIView.animate(withDuration: 1, animations: {
                leftCell?.backgroundColor = .clear
                rightCell?.backgroundColor = .clear
            })
            leftTableView.deselectRow(at: IndexPath.init(item: leftIndex, section: 0), animated: true)
            rightTableView.deselectRow(at: IndexPath.init(item: rightIndex, section: 0), animated: true)
        }
        
        
        leftIndex = -1
        rightIndex = -1
    }
}
