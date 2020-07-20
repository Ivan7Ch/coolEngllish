//
//  VocabulariesViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 05.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import AVFoundation


fileprivate enum VocabularyState {
    case learn
    case recall
    case learned
}


class VocabulariesViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var controlButton: UIButton!
    
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    var visibleWords = [Word]()
    
    fileprivate var state = VocabularyState.learn
    
    var wordsForLearning = [Word]()
    
    var wordsForRecall = [Word]()
    
    var learnedWords = [Word]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false
        title = "Vocabulary"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        wordsForLearning = DictionaryManager.shared.getWordsForStudy()
        wordsForRecall = DictionaryManager.shared.getWordsForRecall()
        learnedWords = DictionaryManager.shared.getLearnedWords()
        
        setupViews()
    }
    
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        visibleWords = DictionaryManager.shared.getWordsForStudy()
        controlButton.blurView(style: .systemChromeMaterial)
        segmentedControl.addTarget(self, action: #selector(segmentedControlAction(segmentedControl:)), for: .valueChanged)
        reloadViews()
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Not enough words to study", message: "You should collect at least 6 words.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func reloadViews() {
        switch state {
        case .learn:
            hideButton(false)
            controlButton.setTitle("Learn Words", for: .normal)
            visibleWords = wordsForLearning
            if wordsForLearning.count == 0 {
                hideButton(true)
                controlButton.setTitle("", for: .normal)
            }
            
        case .recall:
            hideButton(false)
            controlButton.setTitle("Recall Words", for: .normal)
            visibleWords = wordsForRecall
            if wordsForRecall.count == 0 {
                hideButton(true)
                controlButton.setTitle("", for: .normal)
            }
            
        case .learned:
            hideButton(true)
            controlButton.setTitle("", for: .normal)
            visibleWords = learnedWords
        }
        tableView.reloadData()
    }
    
    
    private func hideButton(_ hide: Bool) {
        self.buttonHeightConstraint.constant = hide ? -200 : 50
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func showStudyViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "StudyViewController") as! StudyViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func showRecallViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RecallViewController") as! RecallViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func showAddNewWordsViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddNewWordsViewController") as! AddNewWordsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func controlButtonAction() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if wordsForLearning.count < 6 {
                showAlert()
            } else {
                showStudyViewController()
            }
        case 1:
            showRecallViewController()
        default:
            break
        }
    }
    
    
    @IBAction func segmentedControlAction(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            state = .learn
        case 1:
            state = .recall
        default:
            state = .learned
        }
        reloadViews()
    }
    
    
    @IBAction func addNewWords() {
        
        let alert = UIAlertController(title: "English Level", message: "Select your english level", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Beginer", style: .default , handler:{ (UIAlertAction) in
            UserDefaults.standard.set(EnglishLevel.beginer.rawValue, forKey: "englishLevel")
            self.showAddNewWordsViewController()
        }))
        
        alert.addAction(UIAlertAction(title: "Intermediate", style: .default , handler:{ (UIAlertAction) in
            UserDefaults.standard.set(EnglishLevel.intermediate.rawValue, forKey: "englishLevel")
            self.showAddNewWordsViewController()
        }))
        
        alert.addAction(UIAlertAction(title: "Advanced", style: .default , handler:{ (UIAlertAction) in
            UserDefaults.standard.set(EnglishLevel.advanced.rawValue, forKey: "englishLevel")
            self.showAddNewWordsViewController()
        }))
        
        alert.addAction(UIAlertAction(title: "Native", style: .default , handler:{ (UIAlertAction) in
            UserDefaults.standard.set(EnglishLevel.native.rawValue, forKey: "englishLevel")
            self.showAddNewWordsViewController()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
