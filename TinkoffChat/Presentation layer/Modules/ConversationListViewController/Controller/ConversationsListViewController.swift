//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 27/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit
import Firebase
//import Firestore

class ConversationsListViewController: UIViewController {
    
    let chService: ChannelServiceProtocol = ChannelService()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: String(describing: ConversationCell.self),
                                     bundle: Bundle.main),
                               forCellReuseIdentifier: String(describing: ConversationCell.self))
        }
    }
    
    var onlineChannels = [Channel]()
    var historyChannels = [Channel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.backBarButtonItem?.tintColor = .black
        title = "TinkoffChat"
        
        chService.addChannelListener { [weak self] (channels) in
            guard let channels = channels else { return }
            let date: Date = Date(timeIntervalSinceNow: -600)
            self?.onlineChannels = channels.filter({ channel -> Bool in
                if let lastActivity = channel.lastActivity {
                    return lastActivity > date
                }
                return false
            })
            self?.historyChannels = channels.filter({ channel -> Bool in
                if let lastActivity = channel.lastActivity {
                    return lastActivity < date
                }
                return true
            })
            
            // Sort by date
            self?.onlineChannels.sort(by: { (channel1, channel2) -> Bool in
                guard let lastActivity1 = channel1.lastActivity,
                    let lastActivity2 = channel2.lastActivity else { return true }
                return lastActivity1 > lastActivity2
            })
            self?.historyChannels.sort(by: { (channel1, channel2) -> Bool in
                guard let lastActivity1 = channel1.lastActivity,
                    let lastActivity2 = channel2.lastActivity else { return true }
                return lastActivity1 < lastActivity2
            })
            
            // Sort by empty last activity
            self?.historyChannels.sort(by: { (channel1, channel2) -> Bool in
                return channel1.lastActivity != nil || channel2.lastActivity != nil
            })
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConversation" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let conversationVC = segue.destination as! ConversationViewController
            let channel = indexPath.section == 0 ? onlineChannels[indexPath.row] : historyChannels[indexPath.row]
            
            conversationVC.channelIdentifier = channel.identifier
            conversationVC.title = channel.name
        }
    }
    
    @IBAction func addChannelButton(_ sender: Any) {
        showNewChannelAlert()
    }
    
    func showNewChannelAlert() {
        
        let newChannelAlert = UIAlertController(title: "Enter channel name", message: nil, preferredStyle: .alert)
        
        newChannelAlert.addTextField { (textField : UITextField!) -> Void in
            textField.textAlignment = .center
            textField.placeholder = "Enter channel name "
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let firstTextField = newChannelAlert.textFields![0] as UITextField
            guard let name = firstTextField.text, !name.isEmpty else { return }
            self.chService.createChannel(name: name)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        newChannelAlert.addAction(okAction)
        newChannelAlert.addAction(cancel)
        self.present(newChannelAlert, animated: true, completion: nil)
    }
}

