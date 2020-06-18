//
//  IllegalViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 31.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import AVFoundation


class IllegalViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var videoView: UIView!
    
    var video: VideoModel!
    
    var startTimes = [Double]()
    
    private var player: AVPlayer!
    
    var videoLastSubtitleTime: Double = 0
    
    var subsIndex = 0
    
    var realmWords = [Word]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        video = VideoModel(id: 0, name: "Pes", playlist: 0, placeholder: "", subtitlesId: 0, subtitles: [], url: getUrl(4))
        replaceSubtitles()
        
        title = video.name
        setupPlayer()
        setupSubtitles()
        configTable()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    func getUrl(_ episode: Int) -> String {
        let urlString = "https://fenglish.ru/movie/the_end_of_the_fucking_world-s01e0\(episode)/"
        guard let myURL = URL(string: urlString) else { return "" }

        let htmlStr = try? String(contentsOf: myURL, encoding: .ascii)
        let components = htmlStr?.components(separatedBy: "<source src=\"")
        let videoUrls = components?[1].components(separatedBy: "\" type=")

        return videoUrls?.first ?? ""
    }
    
    
    @IBAction func prev5sec() {
        let time = player.currentTime()
        player.seek(to: time.timeWithOffset(offset: -5))
    }
    
    @IBAction func next5sec() {
        let time = player.currentTime()
        player.seek(to: time.timeWithOffset(offset: 5))
    }
    
    
    @IBAction func playerPause() {
        player.pause()
    }
    
    @IBAction func playerPlay() {
        player.play()
    }
    
    
    func playVideo(){
        let url = URL(string: video.url)!
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        realmWords = DictionaryManager.shared.getAllWords()
        playVideo()
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
            
            var realmWordsDict = [String: Int]()
            for (index, value) in self.realmWords.enumerated() {
                realmWordsDict[value.original] = index
            }
            
            for i in dict.sorted(by: { $0.1 < $1.1 }) {
                if let ind = realmWordsDict[i.key] {
                    let rw = self.realmWords[ind]
                    if rw.progress != -1 { continue }
                    if !top400.contains(String(i.key)) {
                        res.append(rw)
                    }
                }
            }
            
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "VocabularyBoxViewController") as! VocabularyBoxViewController
                vc.visibleWords = res
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension IllegalViewController: UITableViewDataSource, UITableViewDelegate {
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
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sub = video.subtitles[indexPath.row]
        let startTime = sub.start
    }
    
    
    func setSelectedCell(index: Int) {
        video.subtitles[index].isWatched = true
        tableView.reloadData()
    }
    
    func wordTapHandler(word: String) {
        guard let w = DictionaryManager.shared.getWord(word.lowercased()) else { return }
        
    }
}

private extension CMTime {

    func timeWithOffset(offset: TimeInterval) -> CMTime {

        let seconds = CMTimeGetSeconds(self)
        let secondsWithOffset = seconds + offset

        return CMTimeMakeWithSeconds(secondsWithOffset, preferredTimescale: timescale)

    }

}
