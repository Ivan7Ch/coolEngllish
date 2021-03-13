//
//  SettingsViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 09.03.2021.
//  Copyright © 2021 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var source = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        source = ["item1"]
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutorizationTableViewCell") as! SetupableCell
        cell.setup()
        return cell
    }
}

protocol SetupableCell: UITableViewCell {
    func setup()
}


class AutorizationTableViewCell: UITableViewCell, SetupableCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 16
    }
    
    func setup() {
//        infoLabel.text = source[indexPath.row]
    }
}
