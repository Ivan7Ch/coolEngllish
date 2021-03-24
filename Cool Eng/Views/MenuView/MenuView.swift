//
//  MenuView.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 22.03.2021.
//  Copyright © 2021 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var outlineView: UIView!
    
    @IBOutlet weak var menuOption1: UIView!
    @IBOutlet weak var menuOption2: UIView!
    @IBOutlet weak var menuOption3: UIView!
    
    var closure1: () -> () = {}
    var closure2: () -> () = {}
    var closure3: () -> () = {}
    var dissmissClosure: () -> () = {}
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle.init(for: MenuView.self)
        if let viewsToAdd = bundle.loadNibNamed("MenuView", owner: self, options: nil), let contentView = viewsToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            menuContainer.layer.cornerRadius = 5
            menuContainer.backgroundColor = .clear
            menuContainer.applyBlurEffect()
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
            outlineView.addGestureRecognizer(tap)
            
            addTargets()
        }
    }
    
    private func addTargets() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(applyClosure1))
        menuOption1.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(applyClosure2))
        menuOption2.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(applyClosure3))
        menuOption3.addGestureRecognizer(tap3)
    }
    
    @IBAction func applyClosure1() {
        closure1()
        dismiss()
    }
    
    @IBAction func applyClosure2() {
        closure2()
        dismiss()
    }
    
    @IBAction func applyClosure3() {
        closure3()
        dismiss()
    }
    
    
    @IBAction func dismiss() {
        removeFromSuperview()
        dissmissClosure()
    }
}


extension UIView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: self.traitCollection.userInterfaceStyle == .dark ? .dark : .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
}
