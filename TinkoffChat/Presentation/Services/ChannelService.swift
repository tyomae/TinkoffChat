//
//  ChannelService.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 21/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import Firebase

protocol ChannelServiceProtocol {
    func addChannelListener(handler: @escaping ([Channel]?, Error?) -> ())
    func createChannel(name: String)
}

class ChannelService: ChannelServiceProtocol {
    
    private lazy var db = Firestore.firestore()
    private lazy var reference: CollectionReference = db.collection("channels")
    
    func addChannelListener(handler: @escaping ([Channel]?, Error?) -> ()) {
        
        reference.addSnapshotListener { snapshot, error in
            if let snapshot = snapshot {
                let channels = snapshot.documents.map { (document) -> Channel in
                    var activityDate: Date?
                    if let lastActivity = document.data()["lastActivity"] as? Timestamp {
                        activityDate = lastActivity.dateValue()
                    }
                    return Channel(identifier: document.documentID,
                                   name: document.data()["name"] as! String,
                                   lastMessage: (document.data()["lastMessage"] as? String ?? ""),
                                   lastActivity: activityDate)
                }
                handler(channels, nil)
            }
            handler(nil, error)
        }
    }
    
    func createChannel(name: String) {
        
        let channel = Channel(identifier: UUID().uuidString, name: name, lastMessage: "")
        reference.addDocument(data: channel.toDict) { (error) in
            print(error ?? "")
        }
    }
}
