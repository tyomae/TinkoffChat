//
//  MessageService.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 21/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol MessageServiceProtocol {
    func addMessageListener(handler: @escaping ([Message]?) -> ())
    func sendMessage(content: String)
}

class MessageService: NSObject, MessageServiceProtocol {
    
    private let coreDataStack = CoreDataStack()
    private let messageFetchRequester = MessageFetchRequester()
    private lazy var db = Firestore.firestore()
    private lazy var reference: CollectionReference = db.collection("channels")
        .document(channelID).collection("messages")
    
    private let channelID: String
    private let storeManager: StorageManagerProtocol = StorageManager()
    private lazy var fetchResultController: NSFetchedResultsController<MessageEntity> = {
        return NSFetchedResultsController(fetchRequest: messageFetchRequester.fetchMessagesFrom(conversationId: self.channelID),
                                          managedObjectContext: coreDataStack.mainContext,
                                          sectionNameKeyPath: "created",
                                          cacheName: nil)
    }()
    
    private var _handler: (([Message]?) -> ())?
    
    init(channelID: String) {
        self.channelID = channelID
        super.init()
        
        self.fetchResultController.delegate = self
        try? self.fetchResultController.performFetch()
    }
    
    
    func addMessageListener(handler: @escaping ([Message]?) -> ()) {
        _handler = handler
        updateMessages()
        reference.addSnapshotListener { [unowned self] snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let saveContext = self.coreDataStack.saveContext
            
            saveContext.perform {
                
                let oldMessageEntities = MessageEntity.findMessagesFrom(conversationId: self.channelID, in: saveContext, by: self.messageFetchRequester)
                oldMessageEntities?.forEach({
                    saveContext.delete($0)
                })
                
                snapshot.documents.forEach { document in
                    var senderId = ""
                    if let id = document.data()["senderId"] as? String {
                        senderId = id
                    } else if let id = document.data()["senderID"] as? String {
                        senderId = id
                    }
                    
                    let messageEntity = MessageEntity.insertNewMessage(in: saveContext)
                    messageEntity.content = document.data()["content"] as! String
                    messageEntity.created = (document.data()["created"] as? Timestamp)?.dateValue() ?? Date()
                    messageEntity.senderId = senderId
                    messageEntity.senderName = document.data()["senderName"] as! String
                    messageEntity.conversationId = self.channelID
                }
                self.coreDataStack.performSave(context: saveContext, completionHandler: nil)
            }
        }
    }
    
    
    func sendMessage(content: String) {
        if let userInfo = storeManager.loadAppUser() {
            let message = Message(content: content,
                                  created: Date(),
                                  senderID: userID,
                                  senderName: userInfo.name ?? "Artem Emelianov") // Временно, тк пользователь может не указать имя в профиле
            reference.addDocument(data: message.toDict) { (error) in
                print(error ?? "")
            }
        }
    }
}

extension MessageService: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.updateMessages()
        }
    }
    
    func updateMessages() {
        guard let fetchedObjects = fetchResultController.fetchedObjects else { return }
        let messages = fetchedObjects.map({
            return Message(content: $0.content,
                           created: $0.created ?? Date(),
                           senderID: $0.senderId,
                           senderName: $0.senderName)
            
        })
        _handler?(messages)
    }
}
