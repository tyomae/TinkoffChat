//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 27/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: String(describing: ConversationCell.self),
                                     bundle: Bundle.main),
                               forCellReuseIdentifier: String(describing: ConversationCell.self))
        }
    }
    
    let onlineUserConversations = [ConversationCellModel(name: "Dmitry",
                                                         message: "It looks good,but it does not work well",
                                                         date: Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: false),
                                   ConversationCellModel(name: "Tatyana Svyatysheva",
                                                         message: " i'll be out in 20 minutes",
                                                         date: Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: true),
                                   ConversationCellModel(name: "Eurotrip",
                                                         message: nil,
                                                         date: Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: false),
                                   ConversationCellModel(name: "M N",
                                                         message: "how long will you be there",
                                                         date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: false),
                                   ConversationCellModel(name: "Sergey Ostanin",
                                                         message: "ok",
                                                         date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: true),
                                   ConversationCellModel(name: "Maryna Maryna Maryna Maryna",
                                                         message: nil,
                                                         date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: false),
                                   ConversationCellModel(name: "Igor",
                                                         message: "github/tyomae",
                                                         date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: true),
                                   ConversationCellModel(name: "TFS20s iOS Conversation",
                                                         message: "Привет, еще раз поздравляем вас с поступлением в финтех школу",
                                                         date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: false),
                                   ConversationCellModel(name: "HELLOO",
                                                         message: "Hi",
                                                         date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: true),
                                   ConversationCellModel(name: "Saved Messages",
                                                         message: nil,
                                                         date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: false)]
    let historyConversations = [ConversationCellModel(name: "Mickey",
                                                      message: "It looks good,but it does not work well",
                                                      date: Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: false),
                                ConversationCellModel(name: "Anna Revutskaya",
                                                      message: " i'll be out in 50 minutes",
                                                      date: Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: true),
                                ConversationCellModel(name: "Birthday",
                                                      message: "what do u want to present?",
                                                      date: Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: false),
                                ConversationCellModel(name: "A V",
                                                      message: "how long will you be there",
                                                      date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: true),
                                ConversationCellModel(name: "Sergey Ostanin",
                                                      message: "ok",
                                                      date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: false),
                                ConversationCellModel(name: "Maryna Maryna Maryna Maryna",
                                                      message: "Вторая секция с хидером секции с текстом History (в ней будут храниться непустые диалоги с адресатами, недоступными для переписки)",
                                                      date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: false),
                                ConversationCellModel(name: "STEPAN",
                                                      message: "github/tyomae",
                                                      date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: true),
                                ConversationCellModel(name: "TFS20s iOS Conversation",
                                                      message: "Привет, еще раз поздравляем вас с поступлением в финтех школу",
                                                      date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: false),
                                ConversationCellModel(name: "Hello",
                                                      message: "Hi",
                                                      date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: true),
                                ConversationCellModel(name: "Saved Messages",
                                                      message: "Если пользователь online - то делаем фон ячейки бледно-желтым цветом. Оффлайн - оставляем белым.",
                                                      date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: false)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.backBarButtonItem?.tintColor = .black
        title = "TinkoffChat"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConversation" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let conversationVC = segue.destination as! ConversationViewController
            if indexPath.section == 0 {
                conversationVC.title = onlineUserConversations[indexPath.row].name
            } else {
                conversationVC.title = historyConversations[indexPath.row].name
            }
        }
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toConversation", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return onlineUserConversations.count
        }
        return historyConversations.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        }
        return "History"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ConversationCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.configure(with: onlineUserConversations[indexPath.row])
        } else {
            cell.configure(with: historyConversations[indexPath.row])
        }
        return cell
    }
}
