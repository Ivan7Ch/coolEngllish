//
//  AdvertHelperExtension.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 02.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import GoogleMobileAds

// MARK: - Adverts
extension VideoPlayerViewController {
    func setupAdvert() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9391157593798156/8400807389")
        let request = GADRequest()
        interstitial.load(request)
    }
    
    
    func showAdvert() {
        return
        if lastAdvertPresentation() < -15 { return }
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            UserDefaults.standard.set(Date(), forKey: "lasdAdvert")
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                    UserDefaults.standard.set(Date(), forKey: "lasdAdvert")
                }
            })
        }
    }
    
    
    func lastAdvertPresentation() -> Int {
        guard let date = UserDefaults.standard.object(forKey: "lasdAdvert") as? Date else {
            UserDefaults.standard.set(Date(), forKey: "lasdAdvert")
            return Int.max
        }
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm"
        
        let timeDate = date
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: Date())
        
        let difference = calendar.dateComponents([.minute], from: timeComponents, to: nowComponents).minute!
        
        return difference
    }
}
