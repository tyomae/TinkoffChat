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
    var sendMessageButtonLocked = false
    
    private let keyboardManager = KeyboardManager()
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: String(describing: MessageeCell.self),
                                     bundle: Bundle.main),
                               forCellReuseIdentifier: String(describing: MessageeCell.self))
        }
    }
    
    @IBAction func sendMessageTapped(_ sender: UIButton) {
        guard let messageText = messageTextField.text, !messageText.isEmpty else { return }
        msgService.sendMessage(content: messageText)
        messageTextField.text = ""
        sendMessageButtonLocked = false
        sendMessageButton.isEnabled = false
        sendMessageButton.setImage(#imageLiteral(resourceName: "SendIcon.pdf"), for: .normal)
        changeButtonSize()
    }
    
    var messages = [Message]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableViewScrollToBottom(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        self.sendMessageButton.isEnabled = false
        
        msgService.addMessageListener { [weak self] (messages) in
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
        
        keyboardManager.keyboardWillChangeState = { [weak self] state, keyboardSize in
            guard let self = self else { return }
            switch state {
            case .show where self.view.frame.origin.y < 0:
                return
            case .hide where self.view.frame.origin.y >= 0:
                return
            default: break
            }
            UIView.animate(withDuration: 0.5, delay: 0,
                           options: .allowAnimatedContent, animations: { [weak self] in
                            switch state {
                            case .show:
                                self?.view.frame.origin.y -= keyboardSize.height
                            case .hide:
                                self?.view.frame.origin.y += keyboardSize.height
                            }
                }, completion: { _ in
                    self.tableViewScrollToBottom(animated: true)
                    
            })
        }
        
        self.messageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        let numberOfSections = self.tableView.numberOfSections
        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
        
    }
    
    func changeButtonSize() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut], animations: {
            self.sendMessageButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut], animations: {
                self.sendMessageButton.transform = .identity
            })
        })
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if messageTextField.text!.isEmpty {
                if (sendMessageButtonLocked == true) {
                    sendMessageButtonLocked = false
                    sendMessageButton.isEnabled = false
                    changeButtonSize()
                    sendMessageButton.setImage(#imageLiteral(resourceName: "SendIcon.pdf"), for: .normal)
                }
            } else {
                if ( sendMessageButtonLocked == false) {
                    sendMessageButtonLocked = true
                    sendMessageButton.isEnabled = true
                    changeButtonSize()
                    self.sendMessageButton.setImage(#imageLiteral(resourceName: "SendIconEnabled"), for: .normal)
                }
            }
    }

}
