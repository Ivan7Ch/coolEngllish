r//
//  Alert.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 25.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//


import UIKit

extension UIViewController {
    
    func showAlert() {
        let toastLabel = UILabel()
        toastLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = "Vocabulary Box"
        toastLabel.layer.cornerRadius = 6
        toastLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        toastLabel.alpha = 1.0

        toastLabel.clipsToBounds  =  true

        let toastWidth: CGFloat = toastLabel.intrinsicContentSize.width + 16
        let toastHeight: CGFloat = 32
        
        
        
        
        let subLabel = UILabel()
        subLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        subLabel.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        subLabel.textAlignment = .center
        subLabel.text = "\(submessage)"
        subLabel.layer.cornerRadius = 6
        subLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        subLabel.alpha = 1.0

        subLabel.clipsToBounds  =  true

        let subWidth: CGFloat = subLabel.intrinsicContentSize.width + 16
        let subHeight: CGFloat = 38
        
        
        var containerWidth = toastWidth
        if toastWidth < subWidth {
            containerWidth = subWidth
        }
        containerWidth += 12
        
        
        let container = UIView()
        container.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        container.frame = CGRect(x: self.view.frame.width / 2 - (containerWidth / 2),
                                 y: self.view.frame.height - (toastHeight * 1.5) - toastHeight,
                                 width: containerWidth, height: (subHeight * 2)-16)
        container.layer.cornerRadius = 4
        
        toastLabel.frame = CGRect(x: 0, y: 0, width: containerWidth, height: subHeight)
        subLabel.frame = CGRect(x: 0, y: subHeight - 16, width: containerWidth, height: subHeight)
        
        container.addSubview(subLabel)
        container.addSubview(toastLabel)
        container.layer.borderWidth = 1
        container.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.view.addSubview(container)
        
        UIView.animate(withDuration: 0.15, animations: {
            container.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0.8, animations: {
                container.alpha = 0.1
            }) { _ in
                container.removeFromSuperview()
            }
        }
    }
}
