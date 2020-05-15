//
//  VideoPlayerViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import AVFoundation
import ActiveLabel


class VideoPlayerViewController: UIViewController {

    @IBOutlet weak var videoPlayer: YoutubePlayerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerHeightConstraint: NSLayoutConstraint!
    
    var video: VideoModel!
    
    var startTimes = [Double]()
    
    private var player: AVPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let subtitles = SubtitleModel(start: 0.0, eng: " pespes, kitkit #konoplia and some others animals", ru: "рускі тваринки не вщот")
//        video = VideoModel(id: 0, name: "Sobaka", playlist: 1, placeholder: "", subtitlesId: 1, subtitles: [subtitles], url: "")
        
        title = video.name
        setupPlayer()
        setupSubtitles()
        configTable()
        
        SubtitlesFirebaseHelper.shared.fetchSubtitles(videoId: video.id, callback: { sub in
            self.video.subtitles = sub
            self.setupSubtitles()
            self.tableView.reloadData()
        })
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
        
        var newSubs = [SubtitleModel]()
        for sub in video.subtitles {
            var engStr = sub.eng
            var ruStr = sub.ru
            
            if sub.eng.last?.isNewline ?? false {
                engStr = String(sub.eng.dropLast())
            }
            
            if sub.ru.last?.isNewline ?? false {
                ruStr = String(sub.ru.dropLast())
            }
            
            let newSub = SubtitleModel(start: sub.start, eng: engStr, ru: ruStr)
            newSubs.append(newSub)
        }
        video.subtitles = newSubs
        
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
        cell.wordTapHandler = { word in
            self.wordTapHandler(word: word)
        }
        
        if sub.isWatched {
            cell.indicator.backgroundColor = UIColor(named: "indicator")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sub = video.subtitles[indexPath.row]
        let startTime = sub.start
        videoPlayer.seek(to: Float(startTime), allowSeekAhead: true)
    }
    
    
    func setSelectedCell(index: Int) {
        video.subtitles[index].isWatched = true
        tableView.reloadData()
    }
    
    func wordTapHandler(word: String) {
        self.showToast(message: "\(word)", submessage: "винаходити")
    }
}


class SubtitlesTableViewCell: UITableViewCell {
    @IBOutlet weak var originalText: ActiveLabel!
    @IBOutlet weak var translatedText: UILabel!
    @IBOutlet weak var indicator: UIView!
    
    var wordTapHandler: (String) -> () = {_ in }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        setupActiveLabel()
    }
    
    
    private func setupActiveLabel() {
        originalText.numberOfLines = 0
        originalText.hashtagColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        originalText.handleHashtagTap {
            self.wordTapHandler($0)
        }
    }
}
