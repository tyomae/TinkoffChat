//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 27/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: String(describing: IncomingMessageCell.self),
                                     bundle: Bundle.main),
                               forCellReuseIdentifier: String(describing: IncomingMessageCell.self))
            tableView.register(UINib(nibName: String(describing: OutgoingMessageCell.self),
                                     bundle: Bundle.main),
                               forCellReuseIdentifier: String(describing: OutgoingMessageCell.self))
        }
    }
    
    let messages = [MessageCellModel(text: "Hello, how are u?"), MessageCellModel(text: "Hi! Im fine. I hear the new software is almost complete. But does it work?"), MessageCellModel(text: "It looks good,but it does not work well")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ConversationViewController: UITableViewDelegate {
    
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 2 {
            let identifier = String(describing: IncomingMessageCell.self)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? IncomingMessageCell else { return UITableViewCell() }
            cell.configure(with: messages[indexPath.row])
            return cell
        } else {
            let identifier = String(describing: OutgoingMessageCell.self)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? OutgoingMessageCell else { return UITableViewCell() }
            cell.configure(with: messages[indexPath.row])
            return cell
        }
    }  
}
