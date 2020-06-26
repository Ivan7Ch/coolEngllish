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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        durationLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        durationLabel.layer.masksToBounds = true
        durationLabel.layer.cornerRadius = 10
        containerView.layer.cornerRadius = 14
        containerView.layer.masksToBounds = true
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
            cell.thumbnail.kf.setImage(with: url, placeholder: image, completionHandler: { _ in
                let color = (cell.thumbnail.image?.averageColor)!
                cell.containerView.backgroundColor = color
                cell.title.textColor = color.isDarkColor ? .white : .black
            })
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


extension UIImage {
    var averageColor: UIColor? {
        let start = CFAbsoluteTimeGetCurrent()

        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        let diff = CFAbsoluteTimeGetCurrent() - start
        print("Took \(diff) seconds")
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}


func getComplementaryForColor(color: UIColor) -> UIColor {
    
    let ciColor = CIColor(color: color)
    
    // get the current values and make the difference from white:
    let compRed: CGFloat = 1.0 - ciColor.red
    let compGreen: CGFloat = 1.0 - ciColor.green
    let compBlue: CGFloat = 1.0 - ciColor.blue
    
    return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
}


extension UIColor
{
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
    }
}
