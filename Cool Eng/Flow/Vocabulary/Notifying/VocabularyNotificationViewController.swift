//
//  VocabularyNotificationViewController.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 18.03.2021.
//  Copyright © 2021 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import UserNotifications


class VocabularyNotificationViewController: UIViewController {
    
    @IBOutlet weak var wordsList: VocabularyTableView!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var startNotifButton: UIView!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageView: UIView!
    
    var frequency: Double = 5 {
        didSet {
            frequencyLabel.text = "Frequency: \(Int(frequency)) sec"
            UserDefaults.standard.set(Int(frequency), forKey: "notificationFrequency")
        }
    }
    
    var isStartedNotifying = false
    var words = [Word]()
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    
    override func viewDidLoad() {
        wordsList.source = words
        wordsList.tableView.reloadData()
        
        stepper.minimumValue = 10
        stepper.maximumValue = 120
        stepper.value = 15
        
        startNotifButton.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer(target: self, action: #selector(startNotifyingAction))
        startNotifButton.addGestureRecognizer(tap)
        
        wordsList.tableView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.09281630743)
        wordsList.layer.cornerRadius = 16
        tableHeightConstraint.constant = 330
        messageView.isHidden = true
        
        let f = UserDefaults.standard.integer(forKey: "notificationFrequency")
        if f > 5 {
            frequency = Double(f)
        }
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        frequency = sender.value
    }
    
    @IBAction func startNotifyingAction() {
        if isStartedNotifying {
            messageView.isHidden = true
            startNotifButton.backgroundColor = UIColor(named: "main")
            buttonLabel.text = "Start notifying"
            isStartedNotifying = false
            for i in 0..<6 {
                self.sendNotification(words[i], TimeInterval(1), ind: i + 1)
            }
            return
        }
        requestNotificationAuthorization()
        for i in 0..<6 {
            self.sendNotification(words[i], TimeInterval((i * Int(frequency)) + 15), ind: i + 1)
        }
        messageView.isHidden = false
        startNotifButton.backgroundColor = UIColor(named: "incorrectAnswer")
        buttonLabel.text = "Stop notifying"
        isStartedNotifying = true
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification(_ word: Word, _ timeInterval: TimeInterval, ind: Int) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "\(ind)/6 " + word.original.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
        notificationContent.body = word.translation.trimmingCharacters(in: .whitespacesAndNewlines)
        notificationContent.badge = NSNumber(value: 0)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: "\(word.original)", content: notificationContent, trigger: trigger)
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
