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
    
    private let chService: ChannelServiceProtocol = ChannelService()
    
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
    
    @IBAction func addChannelButton(_ sender: Any) {
        showNewChannelAlert()
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toConversation", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let channel = indexPath.section == 0 ? onlineChannels[indexPath.row] : historyChannels[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (_, _) in
            guard let self = self else { return }
            self.chService.remove(id: channel.identifier)
            if indexPath.section == 0 {
                self.onlineChannels.remove(at: indexPath.row)
            } else {
                self.historyChannels.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return onlineChannels.count
        }
        return historyChannels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        }
        return "History"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ConversationCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell else { return UITableViewCell() }
        
        let channel = indexPath.section == 0 ? onlineChannels[indexPath.row] : historyChannels[indexPath.row]
        let conversation = ConversationCellModel(name: channel.name,
                                                 message: channel.lastMessage,
                                                 date: channel.lastActivity,
                                                 isOnline: indexPath.section == 0,
                                                 hasUnreadMessages: false)
        cell.configure(with: conversation)
        return cell
    }
}
