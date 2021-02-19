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
    
    var toastMessageView: ToastMessageView!
    
    var tButton = UIButton()
    
    var video: VideoModel!
    
    var startTimes = [Double]()
    
    private var player: AVPlayer!
    
    var videoLastSubtitleTime: Double = 0
    
    var interstitial: GADInterstitial!
    
    var subsIndex = 0
    
    var realmWords = [Word]()
    
    var learnWordsIds = [Int]()
    
    var foreignSubs = [SubtitleModel]()
    
    var vocabularyBoxIsPresented = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = video.name
        setupPlayer()
        setupSubtitles()
        configTable()
        fetchSubtitles()
        
        
        realmWords = DictionaryManager.shared.getAllWords()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func showAlertIfNeeded() {
        let position = UserDefaults.standard.double(forKey: "video - \(video.id)")
        if position <= 1 { return }
        
        let alert = UIAlertController(title: "Continue", message: "Would you like to continue from the last position", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Continue", style: .default , handler:{ (UIAlertAction) in
            self.videoPlayer.seek(to: Float(position), allowSeekAhead: true)
            guard let ind = self.startTimes.firstIndex(of: position) else { return }
            self.tableView.scrollToRow(at: IndexPath(row: ind, section: 0), at: .top, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction )in
            
        }))

        self.present(alert, animated: true, completion: nil)
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
    
    
    var isPlaying = false
    
    @IBAction func resumeVideo() {
        if isPlaying {
            isPlaying = false
            videoPlayer.pause()
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            isPlaying = true
            videoPlayer.play()
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}
