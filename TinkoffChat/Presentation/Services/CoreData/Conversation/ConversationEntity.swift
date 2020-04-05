//
//  ConversationEntity.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 03/04/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import CoreData

@objc(ConversationEntity)
class ConversationEntity: NSManagedObject {
    
    static func insertConversationWith(id: String,
                                       in context: NSManagedObjectContext) -> ConversationEntity {
        guard let conversation = NSEntityDescription.insertNewObject(forEntityName: "ConversationEntity",
                                                                     into: context)
            as? ConversationEntity else {
                fatalError("Can't insert ConversationEntity")
        }
        conversation.id = id
        return conversation
    }

    static func findConversationWith(conversationId: String,
                                     in context: NSManagedObjectContext,
                                     by conversationRequester: ConversationFetchRequesterProtocol) -> ConversationEntity? {
        let fetchConversationWithId = conversationRequester.fetchConversationWith(conversationId: conversationId)
        do {
            let conversationsWithId = try context.fetch(fetchConversationWithId)
            if !conversationsWithId.isEmpty {
                let conversation = conversationsWithId.first!
                return conversation
            } else {
                return nil
            }
        } catch {
            assertionFailure("Can't get conversations by a fetch")
            return nil
        }
    }

    static func findOrInsertConversationWith(conversationId: String,
                                             in context: NSManagedObjectContext,
                                             by conversationRequester: ConversationFetchRequesterProtocol) -> ConversationEntity {
        guard let conversation = ConversationEntity.findConversationWith(conversationId: conversationId,
                                                                   in: context,
                                                                   by: conversationRequester) else {
            return ConversationEntity.insertConversationWith(id: conversationId, in: context)
        }
        return conversation
    }
}
