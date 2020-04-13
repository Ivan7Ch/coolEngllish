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
}


class VideosListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var videos: [VideoModel] = []
    
    var playlistId: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTable()
        
        title = "Videos"
        navigationController?.navigationBar.prefersLargeTitles = false
        VideoFirebaseHelper.shared.fetchVideos(playlistId: playlistId, callback: { videos in
            self.videos = videos
            self.videos.append(videos[0])
            self.videos.append(videos[0])
            self.videos.append(videos[0])
            self.tableView.reloadData()
        })
    }
    
    func configTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.reloadData()
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
            cell.thumbnail.load(url: url)
        }
        cell.title.text = video.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "VideoPlayerViewController") as! VideoPlayerViewController
        vc.video = videos[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

