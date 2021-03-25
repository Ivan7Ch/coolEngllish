//
//  EditActionsContainerViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 25.03.2021.
//  Copyright © 2021 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class EditActionsContainerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var source = ["Delete", "Add to recall", "Mark as Learned", "Cancel"]
    
    var didSelectCompletion: (Int) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension EditActionsContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditActionsCollectionViewCell", for: indexPath) as! EditActionsCollectionViewCell
        cell.textLabel.text = source[indexPath.row]
        cell.containerView.backgroundColor = UIColor(named: "recallCellColor")
        cell.textLabel.textColor = UIColor(named: "negativeLabel")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width / CGFloat(source.count)) - 4, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! EditActionsCollectionViewCell
        cell.containerView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4, animations: {
            let cell = collectionView.cellForItem(at: indexPath) as! EditActionsCollectionViewCell
            cell.containerView.backgroundColor = UIColor(named: "recallCellColor")
        })
        didSelectCompletion(indexPath.row)
    }
}
