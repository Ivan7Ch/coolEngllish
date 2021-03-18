//
//  VocabulariesViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 05.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import AVFoundation

enum VocabularyState: Int {
    case new = 0
    case recall = 1
    case learned = 2
}

class VocabulariesViewController: UIViewController {
    
    @IBOutlet weak var wordsListView: VocabularyTableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var state = VocabularyState.new {
        didSet {
            reloadViews()
        }
    }
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
        reloadWords()
        reloadViews()
        setupViews()
    }
    
    
    func setupViews() {
        controlButton.blurView(style: .systemChromeMaterial)
        segmentedControl.addTarget(self, action: #selector(segmentedControlAction(segmentedControl:)), for: .valueChanged)
        collectionView.delegate = self
        collectionView.dataSource = self
        reloadViews()
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Not enough words to study", message: "You should collect at least 6 words.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func reloadWords() {
        wordsForLearning = DictionaryManager.shared.getWordsForStudy()
        wordsForRecall = DictionaryManager.shared.getWordsForRecall()
        learnedWords = DictionaryManager.shared.getLearnedWords()
    }
    
    
    @objc func reloadViews() {
        switch state {
        case .new:
            hideButton(false)
            controlButton.setTitle("Learn Words", for: .normal)
            if wordsForLearning.count == 0 {
                hideButton(true)
                controlButton.setTitle("", for: .normal)
            }
        case .recall:
            hideButton(false)
            controlButton.setTitle("Recall Words", for: .normal)
            if wordsForRecall.count == 0 {
                hideButton(true)
                controlButton.setTitle("", for: .normal)
            }
        case .learned:
            hideButton(true)
            controlButton.setTitle("", for: .normal)
        }
        segmentedControl.selectedSegmentIndex = state.rawValue
        DispatchQueue.main.async {
            self.collectionView.isPagingEnabled = false
            self.collectionView.scrollToItem(at: IndexPath(item: self.state.rawValue, section: 0), at: .right, animated: true)
            self.collectionView.isPagingEnabled = true
            self.collectionView.reloadData()
        }
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
    
    
    private func showAddNewWordsViewController(_ level: EnglishLevel) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "VocabularyBoxViewController") as! VocabularyBoxViewController
            vc.words = DictionaryManager.shared.getWordsFor(level: level)
            vc.dissmisCompletion = {
                self.reloadWords()
                self.reloadViews()
            }
            self.present(vc, animated: true, completion: nil)
        }
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
            state = .new
        case 1:
            state = .recall
        default:
            state = .learned
        }
    }
    
    
    @IBAction func addNewWords() {
        
        let alert = UIAlertController(title: "English Level", message: "Select your english level", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Beginer", style: .default , handler:{ (UIAlertAction) in
            UserDefaults.standard.set(EnglishLevel.beginer.rawValue, forKey: "englishLevel")
            self.showAddNewWordsViewController(.beginer)
        }))
        
        alert.addAction(UIAlertAction(title: "Intermediate", style: .default , handler:{ (UIAlertAction) in
            UserDefaults.standard.set(EnglishLevel.intermediate.rawValue, forKey: "englishLevel")
            self.showAddNewWordsViewController(.intermediate)
        }))
        
        alert.addAction(UIAlertAction(title: "Advanced", style: .default , handler:{ (UIAlertAction) in
            UserDefaults.standard.set(EnglishLevel.advanced.rawValue, forKey: "englishLevel")
            self.showAddNewWordsViewController(.advanced)
        }))
        
        alert.addAction(UIAlertAction(title: "Native", style: .default , handler:{ (UIAlertAction) in
            UserDefaults.standard.set(EnglishLevel.native.rawValue, forKey: "englishLevel")
            self.showAddNewWordsViewController(.native)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}


//MARK: - Collection View
extension VocabulariesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 3 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VocabularyCollectionViewCell", for: indexPath) as! VocabularyCollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.setup(wordsForLearning)
        case 1:
            cell.setup(wordsForRecall)
        case 2:
            cell.setup(learnedWords)
        default: break
        }
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - 1, height: collectionView.bounds.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = collectionView.indexPathForItem(at: visiblePoint)
        if let st = VocabularyState(rawValue: indexPath?.row ?? 0) {
            state = st
        }
    }
}


class VocabularyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var wordsListView: VocabularyTableView!
    
    func setup(_ words: [Word]) {
        wordsListView.source = words
        wordsListView.tableView.reloadData()
    }
}


//MARK: - LocalNotifications
extension VocabulariesViewController {
    @IBAction func startNotifying() {
        let vc = storyboard?.instantiateViewController(identifier: "VocabularyNotificationViewController") as! VocabularyNotificationViewController
        if wordsForLearning.count < 6 {
            showAlert()
            return
        }
        
        vc.words = Array(wordsForLearning[0..<6])
        self.present(vc, animated: true, completion: nil)
    }
}

