//
//  ChannelService.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 21/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol ChannelServiceProtocol: class {
    func addChannelListener(handler: @escaping ([Channel]?) -> ())
    func createChannel(name: String)
    func remove(id: String)
}

class ChannelService: NSObject, ChannelServiceProtocol {
    
    private let coreDataStack = CoreDataStack()
    private let conversationFetchRequester = ConversationFetchRequester()
    
    private lazy var db = Firestore.firestore()
    private lazy var reference: CollectionReference = db.collection("channels")
    private lazy var fetchResultController: NSFetchedResultsController<ConversationEntity> = {
        return NSFetchedResultsController(fetchRequest: conversationFetchRequester.fetchConversations(),
                                          managedObjectContext: coreDataStack.mainContext,
                                          sectionNameKeyPath: "lastActivity",
                                          cacheName: nil)
    }()
    
    private var _handler: (([Channel]?) -> ())?
    
    override init() {
        super.init()
        
        self.fetchResultController.delegate = self
        try? self.fetchResultController.performFetch()
    }
    
    func addChannelListener(handler: @escaping ([Channel]?) -> ()) {
        _handler = handler
        updateChannels()
        
        reference.addSnapshotListener { [unowned self] snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let saveContext = self.coreDataStack.saveContext
            saveContext.perform {
                snapshot.documents.forEach { document in
                    var activityDate: Date?
                    if let lastActivity = document.data()["lastActivity"] as? Timestamp {
                        activityDate = lastActivity.dateValue()
                    }
                    let conversationEntity = ConversationEntity.findOrInsertConversationWith(conversationId: document.documentID, in: saveContext, by: self.conversationFetchRequester)
                    conversationEntity.id = document.documentID
                    conversationEntity.name = document.data()["name"] as? String ?? ""
                    conversationEntity.lastActivity = activityDate
                    conversationEntity.lastMessageContent = document.data()["lastMessage"] as? String ?? ""
                }
                self.coreDataStack.performSave(context: saveContext, completionHandler: nil)
            }
        }
    }
    
    
    func remove(id: String) {
        reference.document(id).delete()
        let saveContext = self.coreDataStack.saveContext
        guard let conversationObject = ConversationEntity.findConversationWith(conversationId: id, in: saveContext, by: self.conversationFetchRequester) else { return }
        coreDataStack.saveContext.delete(conversationObject)
    }
    
    func createChannel(name: String) {
        
        let channel = Channel(identifier: UUID().uuidString, name: name, lastMessage: "")
        reference.addDocument(data: channel.toDict) { (error) in
            print(error ?? "")
        }
    }
}

extension ChannelService: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.updateChannels()
        }
    }
    
    
    func updateChannels() {
        guard let fetchedObjects = fetchResultController.fetchedObjects else { return }
        let channels = fetchedObjects.map({
            return Channel(identifier: $0.id,
                           name: $0.name,
                           lastMessage: $0.lastMessageContent,
                           lastActivity: $0.lastActivity)
        })
        _handler?(channels)
        
    }
}
