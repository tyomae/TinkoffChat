//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 11.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    
    var coreDataStack: CoreDataStackProtocol { get }
//    var channelService: ChannelServiceProtocol { get }
    var messageService: MessageServiceProtocol { get }
    var conversationRequester: ConversationFetchRequesterProtocol { get }
    var messageRequester: MessageFetchRequesterProtocol { get }
}

class CoreAssembly: ICoreAssembly {
    
    var coreDataStack: CoreDataStackProtocol = CoreDataStack()
//    var channelService: ChannelServiceProtocol = ChannelService.shared
    var messageService: MessageServiceProtocol = MessageService(channelID: "")//------
    var conversationRequester: ConversationFetchRequesterProtocol = ConversationFetchRequester()
    var messageRequester: MessageFetchRequesterProtocol = MessageFetchRequester()
}

