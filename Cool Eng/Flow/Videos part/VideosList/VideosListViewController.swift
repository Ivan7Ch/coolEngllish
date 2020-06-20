//
//  VideosListViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


class SimpleVideoCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        durationLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        durationLabel.layer.masksToBounds = true
        durationLabel.layer.cornerRadius = 10
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
            self.tableView.reloadData()
            self.activityView.stopAnimating()
        })
        tabBarController?.tabBar.isHidden = true
        showActivityIndicator()
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
        
        if let url = URL(string: video.placeholder) {
            let image = UIImage(named: "default")
            cell.thumbnail.kf.setImage(with: url, placeholder: image)
        }
        cell.title.text = video.name
        
        cell.durationLabel.text = "  \(timeFromSeconds(video.duration))  "
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "VideoPlayerViewController") as! VideoPlayerViewController
        vc.video = videos[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
