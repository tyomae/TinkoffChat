//
//  Message.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 03/04/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import CoreData

@objc(MessageEntity)
class MessageEntity: NSManagedObject {
    
    static func insertNewMessage(in context: NSManagedObjectContext) -> MessageEntity {
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "MessageEntity",
                                                                into: context) as? MessageEntity else {
            fatalError("Can't create Message entity")
        }
        return message
    }
}

extension MessageEntity {
    
    static func findMessagesFrom(conversationId: String,
                                 in context: NSManagedObjectContext,
                                 by messageRequester: MessageFetchRequesterProtocol) -> [MessageEntity]? {
        let request = messageRequester.fetchMessagesFrom(conversationId: conversationId)
        do {
            let messages = try context.fetch(request)
            return messages
        } catch {
            assertionFailure("Can't get messages by a fetch.")
            return nil
        }
    }
}
    


