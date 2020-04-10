//
//  MessageeCell.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 21/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit


class MessageeCell: UITableViewCell, ConfigurableView {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var leftViewConstaint: NSLayoutConstraint!
    @IBOutlet var rightViewConstaint: NSLayoutConstraint!
    
    
    func configure(with model: MessageeCellModel) {
        contentLabel.text = model.text
        timeLabel.text = model.stringDate
        nameLabel.text = model.name
        rightViewConstaint.isActive = !model.isIncoming
        leftViewConstaint.isActive = model.isIncoming
    }
}
