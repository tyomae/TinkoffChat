//
//  MessageFirebaseModel.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 02.05.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import Firebase

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
