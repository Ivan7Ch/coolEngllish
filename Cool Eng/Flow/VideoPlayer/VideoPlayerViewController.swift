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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = video.name
        setupPlayer()
        setupSubtitles()
        configTable()
        
        SubtitlesFirebaseHelper.shared.fetchSubtitles(videoId: video.id, callback: { sub in
            self.video.subtitles = sub
            
            DispatchQueue.global(qos: .default).async {
                let start = CFAbsoluteTimeGetCurrent()
                self.setupSubtitles()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                let diff = CFAbsoluteTimeGetCurrent() - start
                print("Took \(diff) seconds")
            }
            self.wordsForLearning()
        })
        
        //        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9391157593798156/8400807389")
        //        let request = GADRequest()
        //        interstitial.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showAdvert()
        realmWords = DictionaryManager.shared.getAllWords()
    }
    
    
    private func showAdvert() {
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
    
    
    private func lastAdvertPresentation() -> Int {
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
                engStr = convertText(engStr)
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
        
        videoLastSubtitleTime = startTimes.last ?? 0
    }
    
    private func convertText(_ text: String) -> String {
        var res = ""
        let div = "​"
        
        let words = text.split { $0.isWhitespace }
        var dict = [String: String]()
        
        for i in realmWords {
            dict[i.original] = i.translation
        }
        
        for i in words {
            let w = i.replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: ",", with: "").lowercased()
            if let _ = dict[String(w)] {
                res = res + " \(i)"
            } else {
                res = res + " \(div)\(i)"
            }
        }
        
        return res
    }
    
    
    func wordsForLearning() {
        DispatchQueue.global(qos: .default).async {
            var res = [Word]()
            var subs = ""
            
            for i in self.video.subtitles {
                subs += i.eng + " "
            }
            
            let words = subs.split{ $0.isWhitespace }
            
            var dict = [String: Int]()
            for i in words {
                let key = String(i)
                if let val = dict[key] {
                    dict[key] = val + 1
                } else {
                    dict[key] = 1
                }
            }
            

            for i in dict.sorted(by: { $0.1 < $1.1 }) {
                if let rw = self.realmWords.first(where: { $0.original == i.key }) {
                    if !top400.contains(String(i.key)) {
                        res.append(rw)

                        if res.count >= 25 {
                            break
                        }
                    }
                }
            }
            
            print(res)
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "VocabularyBoxViewController") as! VocabularyBoxViewController
                vc.words = res
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

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


// MARK: - UITableViewDataSource, UITableViewDelegate
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
        
        cell.index = indexPath.row
        cell.cellTapHandler = { ind in
            let sub = self.video.subtitles[ind]
            let startTime = sub.start
            self.videoPlayer.seek(to: Float(startTime), allowSeekAhead: true)
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
        guard let w = DictionaryManager.shared.getSimpleWord(word.lowercased()) else { return }
        self.showToast(message: "\(word)", submessage: w.translation)
    }
}
