//
//  PastelExtension.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 08.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import Pastel


extension UIViewController {
    func setPastelBackground() {
        let pastelView = PastelView(frame: view.bounds)

        pastelView.startPastelPoint = .top
        pastelView.endPastelPoint = .bottom
        pastelView.animationDuration = 7.0
        
        let color1 = UIColor(named: "color1")!
        let color2 = UIColor(named: "color2")!
            
        let colors = [color1, color2]
        
        pastelView.setColors(colors)
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
}
