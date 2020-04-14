//
//  PlaylistsViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import GoogleMobileAds


class PlaylistsViewController: UIViewController, PlaylistDelegate, GADRewardedAdDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PlaylistViewModel!
    
    var rewardedAd: GADRewardedAd?
    
    var canShowAd = false
    
    var selectedCell: PlaylistTableViewCell?
    
    var selectedPlaylistId: String = ""
    
    var showAdvert = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PlaylistViewModel(delegate: self)
        
        setupViews()
        setupAd()
        
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.reloadData()
    }
    
    
    private func setupViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        title = "Playlists"
        
//        let search = UISearchController(searchResultsController: nil)
//        search.searchResultsUpdater = self
//        self.navigationItem.searchController = search
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupAd() {
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-9391157593798156/5256111514")
        rewardedAd?.load(GADRequest()) { error in
            if let error = error {
                print(error)
            } else {
                if self.showAdvert {
                    self.showAd()
                }
                self.canShowAd = true
            }
        }
    }
    
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.showAd()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    
    @IBAction func showAd() {
        showAdvert = true
        if !canShowAd {
            selectedCell?.activitiIndicator.startAnimating()
        } else {
            selectedCell?.activitiIndicator.stopAnimating()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
            self.selectedCell?.activitiIndicator.stopAnimating()
            self.showAdvert = false
        })
        
        rewardedAd?.present(fromRootViewController: self, delegate: self)
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        let vc = storyboard?.instantiateViewController(identifier: "VideosListViewController") as! VideosListViewController
        vc.playlistId = selectedPlaylistId
        navigationController?.pushViewController(vc, animated: true)
        PlaylistsCacheHelper.shared.addNewPlaylist(playlist: selectedPlaylistId)
    }
}


extension PlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.reuseIdentifer) as! PlaylistTableViewCell
        
        let item = viewModel.playlists[indexPath.row]
        
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = tableView.cellForRow(at: indexPath) as! PlaylistTableViewCell
        selectedPlaylistId = viewModel.playlists[indexPath.row].id
        let id = viewModel.playlists[indexPath.row].id
        if !PlaylistsCacheHelper.shared.getPlaylistsId().contains(id) {
            showAlert()
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "VideosListViewController") as! VideosListViewController
            vc.playlistId = selectedPlaylistId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension PlaylistsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
