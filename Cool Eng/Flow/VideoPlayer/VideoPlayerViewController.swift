//
//  VideoPlayerViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import AVFoundation


class VideoPlayerViewController: UIViewController {

    @IBOutlet weak var videoPlayer: YoutubePlayerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerHeightConstraint: NSLayoutConstraint!
    
    var video: VideoModel!
    
    var startTimes = [Double]()
    
    private var player: AVPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = video.name
        setupPlayer()
        setupSubtitles()
        configTable()
    }
    
    
    private func setupPlayer() {
        let playerVars: [String: Any] = [
            "controls": 1,
            "modestbranding": 1,
            "playsinline": 1,
            "origin": "https://youtube.com"
        ]
        videoPlayer.delegate = self
        videoPlayer.loadWithVideoId(video.url, with: playerVars)
    }
    
    
    private func configTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.reloadData()
    }
    
    
    private func setupSubtitles() {
        startTimes = []
        for i in video.subtitles {
            startTimes.append(i.start)
        }
    }
}


extension VideoPlayerViewController: YoutubePlayerViewDelegate {
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        for (index, value) in startTimes.enumerated() {
            if time > Float(value) {
                setSelectedCell(index: index)
            } else {
                break
            }
        }
    }
}


extension VideoPlayerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return video.subtitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitlesTableViewCell") as! SubtitlesTableViewCell
        
        let sub = video.subtitles[indexPath.row]
        
        cell.originalText.text = sub.eng
        cell.translatedText.text = sub.ru
        cell.indicator.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        return cell
    }
    
    func setSelectedCell(index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! SubtitlesTableViewCell
        cell.indicator.backgroundColor = UIColor(named: "indicator")
    }
}


class SubtitlesTableViewCell: UITableViewCell {
    @IBOutlet weak var originalText: UILabel!
    @IBOutlet weak var translatedText: UILabel!
    @IBOutlet weak var indicator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
}
