//
//  TableViewExtension.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 02.06.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


// MARK: - UITableViewDataSource, UITableViewDelegate
extension VideoPlayerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return video.subtitles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitlesTableViewCell") as! SubtitlesTableViewCell
        
        let sub = video.subtitles[indexPath.row]

        cell.originalText.text = sub.eng.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.translatedText.text = sub.ru.trimmingCharacters(in: .whitespacesAndNewlines)
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
        var w = DictionaryManager.shared.getWord(word.lowercased())
        if w == nil {
            w = Word(id: 0, original: word)
        }
        
        if toastMessageView != nil {
            toastMessageView.removeFromSuperview()
        }
        
        self.toastMessageView = ToastMessageView()
        toastMessageView.setup(with: w!)
        view.addSubview(toastMessageView)
    }
}
