//
//  PlaylistsViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


class PlaylistsViewController: UIViewController, PlaylistDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PlaylistViewModel!
    
    var selectedCell: PlaylistTableViewCell?
    
    var selectedPlaylistId: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PlaylistViewModel(delegate: self)
        setupViews()
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
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func upload(error: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("errors").document("error")
        docRef.updateData(["\(Int.random(in: 0...1000000))":"\(error)"])
    }
    
    
    func reloadData() {
        tableView.reloadData()
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
        let vc = storyboard?.instantiateViewController(identifier: "VideosListViewController") as! VideosListViewController
        vc.playlistId = selectedPlaylistId
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension PlaylistsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
    }
}
