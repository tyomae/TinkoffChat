//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 27/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit
import Firebase

class ConversationsListViewController: UIViewController {
    
    let chService: ChannelServiceProtocol = ChannelService(coreDataStack: CoreDataStack(), conversationFetchRequester: ConversationFetchRequester())
    let chSorter: IChannelSorter = ChannelSorter()
    
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
        
        chService.addChannelListener { [weak self] (channels) in
            guard let channels = channels,
                let self = self else { return }
            
            self.onlineChannels = self.chSorter.sortByDate(channels, ascending: true)
            self.historyChannels = self.chSorter.sortByDate(channels, ascending: false)
            
            self.onlineChannels = self.chSorter.sortByOnlineStatus(channels, ascending: true)
            self.historyChannels = self.chSorter.sortByOnlineStatus(channels, ascending: false)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
