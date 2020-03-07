//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 27/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {
    
    
    @IBOutlet weak var backgroundMessage: UIView! {
        didSet {
            backgroundMessage.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var rightBackgroundConstraint: NSLayoutConstraint!
    @IBOutlet var leftBackgroundConstaint: NSLayoutConstraint!
    
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        rightBackgroundConstraint.isActive = !model.isIncoming
        leftBackgroundConstaint.isActive = model.isIncoming
    }
}
