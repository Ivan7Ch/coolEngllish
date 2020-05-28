//
//  Level4ViewController.swift
//  WordsLearner
//
//  Created by Ivan Chernetskiy on 04.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class Level4ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mainWordLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var awardImageView: UIImageView!
    var words = [Word]()
    
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingDidEndOnExit)
        setupViews()
    }
    
    
    private func setupViews() {
        awardImageView.alpha = 0
        mainWordLabel.text = words[currentIndex].translation
    }
    
    private func reloadViews() {
        UIView.animate(withDuration: 0.5, animations: {
            self.awardImageView.alpha = 1
        }, completion: { _ in
            self.textField.becomeFirstResponder()
            self.awardImageView.alpha = 0
            self.mainWordLabel.text = self.words[self.currentIndex].translation
            self.textField.text = ""
        })
    }
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        if sender.text?.lowercased() == words[currentIndex].original.lowercased() {
            sender.becomeFirstResponder()
            currentIndex += 1
            reloadViews()
        }
    }
}
