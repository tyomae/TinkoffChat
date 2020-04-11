//
//  MessageUser+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 03/04/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import CoreData
import Foundation

extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var conversationId: String
    @NSManaged public var created: Date?
    @NSManaged public var content: String
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
 
}
