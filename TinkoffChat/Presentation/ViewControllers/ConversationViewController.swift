//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 27/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var channelIdentifier = ""
    lazy var msgService: MessageServiceProtocol = MessageService(channelID: channelIdentifier)
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBAction func sendMessageTapped(_ sender: UIButton) {
        guard let messageText = messageTextField.text, !messageText.isEmpty else { return }
        msgService.sendMessage(content: messageText)
        messageTextField.text = ""
    }
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: String(describing: MessageeCell.self),
                                     bundle: Bundle.main),
                               forCellReuseIdentifier: String(describing: MessageeCell.self))
        }
    }
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        msgService.addMessageListener { [weak self] (messages, error) in
            guard let messages = messages else { return }
            guard let self = self else { return }
            let messagesShowsFirst = !self.messages.isEmpty
            self.messages = messages
            
            self.messages.sort(by: { (message1, message2) -> Bool in
                return message1.created < message2.created
            })
            self.tableView.reloadData()
            self.tableViewScrollToBottom(animated: messagesShowsFirst)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)  
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        if (self.view.frame.origin.y < 0) {
            return
        }
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.5, delay: 0,
                               options: .allowAnimatedContent, animations: {
                                self.view.frame.size.height -= keyboardSize.height
                                
                }, completion: { _ in
                    self.tableViewScrollToBottom(animated: true)
                    
                })
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if (self.view.frame.origin.y >= 0) {
            return
        }
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.5, delay: 0,
                               options: .allowAnimatedContent, animations: {
                                self.view.frame.size.height += keyboardSize.height
                                
                }, completion: { _ in
                    self.tableViewScrollToBottom(animated: true)
                    
                })
            }
        }
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        let numberOfSections = self.tableView.numberOfSections
        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
        
    }
}

extension ConversationViewController: UITableViewDelegate {
    
}

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
