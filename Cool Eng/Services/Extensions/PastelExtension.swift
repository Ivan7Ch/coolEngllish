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
            
        var colors = [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8904744485, green: 0.8502347224, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.6813562978, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.6451833526, alpha: 1)]
        
        if self.traitCollection.userInterfaceStyle == .dark {
            colors = [#colorLiteral(red: 0.1058823529, green: 0.1490196078, blue: 0.1725490196, alpha: 1), #colorLiteral(red: 0.07348752223, green: 0.2307534394, blue: 0.3196383249, alpha: 1)]
        }
        
        pastelView.setColors(colors)
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
}
