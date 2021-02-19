//
//  VideosListViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import UIImageColors


class SimpleVideoCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var videoProgressView: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        durationLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        durationLabel.layer.masksToBounds = true
        durationLabel.layer.cornerRadius = 10
        containerView.layer.cornerRadius = 14
        containerView.layer.masksToBounds = true
        
        videoProgressView.transform = CGAffineTransform(scaleX: 1, y: 1.5)
    }
}


class VideosListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var videos: [VideoModel] = []
    
    var playlistId: Int = 0
    
    var activityView = UIActivityIndicatorView(style: .large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTable()
        
        title = "Videos"
        navigationController?.navigationBar.prefersLargeTitles = false
        VideoFirebaseHelper.shared.fetchVideos(playlistId: playlistId, callback: { videos in
            self.videos = videos
            self.sortVideos()
            self.tableView.reloadData()
            self.activityView.stopAnimating()
        })
        tabBarController?.tabBar.isHidden = true
        showActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
    }
    
    
    func showActivityIndicator() {
        activityView.center = self.view.center
        activityView.color = UIColor(named: "main")
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    
    func configTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.reloadData()
    }
    
    
    func secondsToHoursMinutesSeconds(seconds : Int) -> [Int] {
        return [seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60]
    }
    
    
    func timeFromSeconds(_ seconds : Int) -> String {
        let duration: TimeInterval = TimeInterval(seconds)

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        if seconds / 3600 <= 0 {
            formatter.allowedUnits = [.minute, .second]
        }
        formatter.zeroFormattingBehavior = [.pad]

        let formattedDuration = formatter.string(from: duration)
        
        return formattedDuration ?? ""
    }
}


extension VideosListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleVideoCell") as! SimpleVideoCell
        let video = videos[indexPath.row]
        
        let image = UIImage(named: "default")
        cell.thumbnail.image = image
        if let url = URL(string: video.placeholder) {
            cell.thumbnail.kf.setImage(with: url, placeholder: image, completionHandler: { _ in
                let color = (cell.thumbnail.image?.averageColor)!
                cell.containerView.backgroundColor = color
                cell.title.textColor = color.isDarkColor ? .white : .black
            })
        }
        cell.title.text = video.name
        
        cell.durationLabel.text = "  \(timeFromSeconds(video.duration))  "
        
        // calculate progress
        cell.videoProgressView.progress = 0
        let position = UserDefaults.standard.double(forKey: "video - \(video.id)")
        let progress = position / Double(video.duration)
        if progress.isNormal {
            cell.videoProgressView.progress = Float(progress)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "VideoPlayerViewController") as! VideoPlayerViewController
        vc.video = videos[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}



// MARK: - Private methods
extension VideosListViewController {
    
    private func sortVideos() {
        videos = videos.sorted(by: { return $0.name < $1.name})
        var watchedVideos = [VideoModel]()
        var notWatchedVideos = [VideoModel]()
        
        for i in videos {
            if UserDefaults.standard.double(forKey: "video - \(i.id)") < 2 {
                notWatchedVideos.append(i)
            } else {
                watchedVideos.append(i)
            }
        }

        videos = []
        for i in notWatchedVideos {
            videos.append(i)
        }

        for i in watchedVideos {
            videos.append(i)
        }
    }
}
