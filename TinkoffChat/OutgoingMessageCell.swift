//
//  OutgoingMessageCell.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 27/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class OutgoingMessageCell: UITableViewCell, ConfigurableView {

    
    @IBOutlet weak var backgroundMessage: UIView! {
        didSet {
            backgroundMessage.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var outgoingMessageLabel: UILabel!
    
    func configure(with model: MessageCellModel) {
        outgoingMessageLabel.text = model.text
       }
}
