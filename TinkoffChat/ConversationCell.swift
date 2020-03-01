//
//  ConversationCell.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 27/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConfigurableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var lastMessafeTimeLabel: UILabel!
    
    func configure(with model: ConversationCellModel) {
        nameLabel.text = model.name
        if model.message == nil {
            lastMessageLabel.text = "No messages yet"
            lastMessageLabel.font = UIFont(name: "Avenir-Light", size: 17.0)
        } else {
            lastMessageLabel.text = model.message
            lastMessageLabel.font = UIFont.systemFont(ofSize: 17)
        }
        lastMessafeTimeLabel.text = model.stringDate
        if model.isOnline {
            backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0.6601287412, alpha: 1)
        } else {
            backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        if model.hasUnreadMessages {
            lastMessageLabel.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        }
    }
    
}
