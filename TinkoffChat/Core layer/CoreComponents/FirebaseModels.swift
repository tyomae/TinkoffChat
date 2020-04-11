//
//  File.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 18/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import Firebase

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String
    var lastActivity: Date?
}

extension Channel {
    var toDict: [String: Any] {
        return ["identifier": identifier,
                "name": name,
                "lastMessage": lastMessage]
    }
}

struct Message {
    let content: String
    let created: Date
    let senderID: String
    let senderName: String
}

extension Message {
    var toDict: [String: Any] {
        return ["content": content,
                "created": Timestamp(date: created),
                "senderId": senderID,
                "senderName": senderName]
    }
}



