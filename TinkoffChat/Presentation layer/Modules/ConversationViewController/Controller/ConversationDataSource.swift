//
//  Conversation TableView.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 11.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import UIKit


extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: MessageeCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageeCell else { return UITableViewCell() }
        let message = messages[indexPath.row]
        let messages = MessageeCellModel(name: message.senderName,
                                         text: message.content,
                                         date: message.created,
                                         isIncoming: message.senderID != userID)
        cell.configure(with: messages)
        return cell
    }
}

