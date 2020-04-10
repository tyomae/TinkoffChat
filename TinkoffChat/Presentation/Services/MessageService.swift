//
//  MessageService.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 21/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import Firebase

protocol MessageServiceProtocol {
    func addMessageListener(handler: @escaping ([Message]?, Error?) -> ())
    func sendMessage(content: String)
}

class MessageService: MessageServiceProtocol {
    
    private lazy var db = Firestore.firestore()
    private lazy var reference: CollectionReference = db.collection("channels")
        .document(channelID).collection("messages")
    
    private let channelID: String
    private let gcdDataManager = GCDDataManager()
    
    init(channelID: String) {
        self.channelID = channelID
    }
    
    func addMessageListener(handler: @escaping ([Message]?, Error?) -> ()) {
        
        reference.addSnapshotListener { snapshot, error in
            if let snapshot = snapshot {
                let messages = snapshot.documents.map { (document) -> Message in
                    var senderId = ""
                    if let id = document.data()["senderId"] as? String {
                        senderId = id
                    } else if let id = document.data()["senderID"] as? String {
                        senderId = id
                    }
                    return Message(content: document.data()["content"] as! String,
                                   created: (document.data()["created"] as? Timestamp)?.dateValue() ?? Date(),
                                   senderID: senderId,
                                   senderName: document.data()["senderName"] as! String)
                }
                handler(messages, nil)
            }
            handler(nil, error)
        }
    }
    
    func sendMessage(content: String) {
        gcdDataManager.loadData { [weak self] (userInfo, _) in
            if let userInfo = userInfo {
                let message = Message(content: content,
                                      created: Date(),
                                      senderID: userID,
                                      senderName: userInfo.userName ?? "Artem Emelianov") // Временно, тк пользователь может не указать имя в профиле
                self?.reference.addDocument(data: message.toDict) { (error) in
                    print(error ?? "")
                }
            }
        }
    }
}
