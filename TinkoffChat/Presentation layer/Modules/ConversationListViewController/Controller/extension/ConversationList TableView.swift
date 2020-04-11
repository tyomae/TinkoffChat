//
//  ConversationList TableView.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 11.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import UIKit


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
