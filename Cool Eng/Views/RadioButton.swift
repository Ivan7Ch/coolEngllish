//
//  RadioButton.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 20.02.2021.
//  Copyright © 2021 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class RadioButton: UIControl {
    
    var outerColor: UIColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    var innerColor: UIColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    var outerRadius: CGFloat = 10
    var innerRadius: CGFloat = 7
    var outerLineWidth: CGFloat = 1.5
    var isOn: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        
        ctx.addArc(center: viewCenter, radius: outerRadius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
        ctx.setStrokeColor(outerColor.cgColor)
        ctx.setLineWidth(outerLineWidth)
        ctx.strokePath()
        
        if isOn {
            ctx.addArc(center: viewCenter, radius: innerRadius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
            ctx.setFillColor(innerColor.cgColor)
            ctx.fillPath()
        }
    }
}
