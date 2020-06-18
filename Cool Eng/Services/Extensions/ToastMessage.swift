//
//  ToastMessage.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 15.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


class ToastMessageView: UIView {
    
    var message = ""
    
    var subMessage = ""
    
    
    var messageLabel: UILabel!
    
    var subMessageLabel: UILabel!
    
    var plusIcon: UIImageView!
    
    lazy var plusButton = UIButton()
    
    var word: Word!
    
    
    
    func setup(with word: Word) {
        self.message = word.original
        self.subMessage = word.translation
        self.word = word
        setupViews()
    }
    
    
    private func addMessageLabel() {
        messageLabel = UILabel()
        messageLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        messageLabel.textAlignment = .center
        messageLabel.text = "\(message.capitalized)"
        messageLabel.layer.cornerRadius = 6
        messageLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        messageLabel.alpha = 1.0
        messageLabel.clipsToBounds  =  true
    }
    
    
    private func addSubmessageLabel() {
        subMessageLabel = UILabel()
        subMessageLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        subMessageLabel.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        subMessageLabel.textAlignment = .center
        subMessageLabel.text = "\(subMessage)"
        subMessageLabel.layer.cornerRadius = 6
        subMessageLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        subMessageLabel.alpha = 1.0
        subMessageLabel.clipsToBounds  =  true
    }
    
    
    private func addPlusIcon() {
        plusIcon = UIImageView()
        plusIcon.frame = CGRect(x: self.bounds.width - 40, y: (bounds.height / 2) - 12, width: 24, height: 24)
        let image = UIImage(systemName: "plus")
        plusIcon.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        plusIcon.image = image
        self.addSubview(plusIcon)
    }
    
    
    private func addPlusButton() {
        let width = bounds.width
        let height = bounds.height
        plusButton.frame = CGRect(x: width - height, y: 0, width: height, height: height)
        plusButton.addTarget(self, action: #selector(plusButtonAction), for: .touchUpInside)
        addSubview(plusButton)
    }
    
    
    @IBAction func plusButtonAction() {
        plusIcon.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        let image = UIImage(systemName: "checkmark.circle")
        plusIcon.image = image
        UIView.animate(withDuration: 0.2, delay: 0.3, animations: {
            self.alpha = 0.1
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.removeFromSuperview()
        })
        print(word.id)
        DictionaryManager.shared.addToDictionary(ids: [word.id])
    }
    
    
    func setupViews() {
        let toastHeight: CGFloat = 32
        let subHeight: CGFloat = 38

        let containerWidth = UIScreen.main.bounds.width - 40

        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.frame = CGRect(x: 20, y: UIScreen.main.bounds.height - (toastHeight * 1.5) - toastHeight, width: containerWidth, height: (subHeight * 2)-16)
        self.layer.cornerRadius = 4

        addPlusIcon()
        addMessageLabel()
        addSubmessageLabel()

        subMessageLabel.frame = CGRect(x: 0, y: subHeight - 16, width: containerWidth, height: subHeight)
        messageLabel.frame = CGRect(x: 0, y: 0, width: containerWidth, height: subHeight)

        self.addSubview(subMessageLabel)
        self.addSubview(messageLabel)
        addPlusButton()
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)


        alpha = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: { [weak self] in
            self?.removeFromSuperview()
        })
    }
}
