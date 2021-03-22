//
//  MenuView.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 22.03.2021.
//  Copyright © 2021 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
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
            contentView.layer.cornerRadius = 40
        }
    }
}
