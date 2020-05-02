//
//  ChannelFirebaseModel.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 18/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

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

extension Channel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}
