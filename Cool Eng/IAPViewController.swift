//
//  IAPViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 23.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import SwiftyStoreKit


class IAPViewController: UIViewController {
    
    @IBOutlet weak var monthlyButton: UIView!
    @IBOutlet weak var annualButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        buyButton.addTarget(self, action: #selector(buyButtonAction), for: .touchUpInside)
        title = "Premium access"
        monthlyButton.layer.cornerRadius = 16
        annualButton.layer.cornerRadius = 16
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(buyButtonAction))
        monthlyButton.addGestureRecognizer(tap)
    }
    
    
    @IBAction func buyButtonAction() {
        purchase()
    }
    
    
    private func purchase() {
        let productId = "subscription1"
        
        SwiftyStoreKit.retrieveProductsInfo(["subscription1"]) { result in
            if let product = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                    // handle result (same as above)
                }
            }
        }
    }
    
}
