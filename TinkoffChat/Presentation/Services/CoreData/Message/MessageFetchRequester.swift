//
//  MessageFetchRequester.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 03/04/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import CoreData


protocol MessageFetchRequesterProtocol {
    func fetchMessagesFrom(conversationId: String) -> NSFetchRequest<MessageEntity>
}

class MessageFetchRequester: MessageFetchRequesterProtocol {
    
    func fetchMessagesFrom(conversationId: String) -> NSFetchRequest<MessageEntity> {
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId == %@", conversationId)
        let sort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sort]
        return request
    }
}
