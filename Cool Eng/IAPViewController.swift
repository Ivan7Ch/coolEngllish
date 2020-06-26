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
    
    @IBOutlet weak var buyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buyButton.addTarget(self, action: #selector(buyButtonAction), for: .touchUpInside)
        title = "Premium access"
        buyButton.layer.cornerRadius = 16
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
