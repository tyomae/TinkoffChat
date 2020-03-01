//
//  IncomingMessageCell.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 27/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class IncomingMessageCell: UITableViewCell, ConfigurableView {

    @IBOutlet weak var backgroundMessageView: UIView! {
        didSet {
            backgroundMessageView.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var incomingMessageLabel: UILabel!
    
    func configure(with model: MessageCellModel) {
        incomingMessageLabel.text = model.text
    }
}
