//
//  ConversationFetchRequest.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 03/04/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationFetchRequesterProtocol {
    func fetchConversations() -> NSFetchRequest<ConversationEntity>
    func fetchConversationWith(conversationId: String) -> NSFetchRequest<ConversationEntity>
}

class ConversationFetchRequester: ConversationFetchRequesterProtocol {

    func fetchConversations() -> NSFetchRequest<ConversationEntity> {
        let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        request.sortDescriptors = [dateSortDescriptor]
        return request
    }

    func fetchConversationWith(conversationId: String) -> NSFetchRequest<ConversationEntity> {
        let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", conversationId)
        return request
    }

}

