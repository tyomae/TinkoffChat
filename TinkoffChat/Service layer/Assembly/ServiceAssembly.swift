//
//  ServiceAssembly.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 12.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    var channelService: ChannelServiceProtocol { get }
    var conversationFetchRequester: ConversationFetchRequesterProtocol { get }
    var messageFetchRequester: MessageFetchRequesterProtocol { get }
    
    func messageService(channelID: String) -> MessageServiceProtocol
}

class ServicesAssembly: IServicesAssembly {
    
    lazy var channelService: ChannelServiceProtocol = ChannelService(coreDataStack: coreAssembly.coreDataStack, conversationFetchRequester: conversationFetchRequester)
    lazy var conversationFetchRequester: ConversationFetchRequesterProtocol = ConversationFetchRequester()
    lazy var messageFetchRequester: MessageFetchRequesterProtocol = MessageFetchRequester()
    
    func messageService(channelID: String) -> MessageServiceProtocol {
        MessageService(channelID: channelID)
    }
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
}