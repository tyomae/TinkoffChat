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
            tableView.register(UINib(nibName: String(describing: MessageCell.self),
                                     bundle: Bundle.main),
                               forCellReuseIdentifier: String(describing: MessageCell.self))
        }
    }
    
    let messages = [MessageCellModel(text: "Hello, how are u?", isIncoming: true), MessageCellModel(text: "Hi! Im fine. I hear the new software is almost complete. But does it work?", isIncoming: false), MessageCellModel(text: "It looks good,but it does not work well", isIncoming: true)]
    
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
        let identifier = String(describing: MessageCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else { return UITableViewCell() }
        cell.configure(with: messages[indexPath.row])
        return cell
    }  
}
