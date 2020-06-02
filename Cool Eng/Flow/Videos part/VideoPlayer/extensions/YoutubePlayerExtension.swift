//
//  YoutubePlayerExtension.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 02.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


// MARK: - YoutubePlayerViewDelegate
extension VideoPlayerViewController: YoutubePlayerViewDelegate {
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        
        var isUpdated = false
        for i in startTimes {
            if time > Float(i) {
                setSelectedCell(index: subsIndex)
                subsIndex += 1
                startTimes.removeFirst()
                isUpdated = true
            } else {
                break
            }
        }
        
        if isUpdated {
            tableView.reloadData()
        }
        
        if time > Float(1.0) {
            showAdvert()
        }
    }
}
