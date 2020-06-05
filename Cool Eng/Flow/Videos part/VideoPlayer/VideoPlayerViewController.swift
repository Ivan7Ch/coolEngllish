//
//  VideoPlayerViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds


class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var videoPlayer: YoutubePlayerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerHeightConstraint: NSLayoutConstraint!
    
    var video: VideoModel!
    
    var startTimes = [Double]()
    
    private var player: AVPlayer!
    
    var videoLastSubtitleTime: Double = 0
    
    var interstitial: GADInterstitial!
    
    var subsIndex = 0
    
    var realmWords = [Word]()
    
    var learnWordsIds = [Int]()
    
    var foreignSubs = [SubtitleModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = video.name
        setupPlayer()
        setupSubtitles()
        configTable()
        fetchSubtitles()
        
        showAdvert()
        realmWords = DictionaryManager.shared.getAllWords()
        tabBarController?.tabBar.isHidden = true
    }


    func setupPlayer() {
        let playerVars: [String: Any] = [
            "controls": 1,
            "modestbranding": 1,
            "playsinline": 1,
            "origin": "https://youtube.com"
        ]
        videoPlayer.delegate = self
        videoPlayer.loadWithVideoId(video.url, with: playerVars)
    }
    
    
    func configTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.reloadData()
    }
    
    
    @IBAction func pauseVideo() {
        videoPlayer.pause()
    }
    
    
    @IBAction func resumeVideo() {
        videoPlayer.play()
    }
}



/*
 private func replaceSubtitles() {
     let filepath = Bundle.main.path(forResource: "ep1", ofType: "txt")!
     let contents = try! String(contentsOfFile: filepath)
     
     let subs = contents.split{ $0.isNewline }
     
     var subsArr = [SubtitleModel]()
     for i in subs {
         let sub = SubtitleModel(start: 123333, eng: " " + String(i), ru: "", isWatched: false)
         subsArr.append(sub)
     }
     video.subtitles = subsArr
 }
 */
