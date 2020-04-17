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
    var conversationRequester: ConversationFetchRequesterProtocol { get }
    var messageRequester: MessageFetchRequesterProtocol { get }
    var requestSender: IRequestSender { get }
    var imageDwnldrConfig: RequestConfig<ImageRequestsStorageParser> { get }
    var imageProvider: IImageProvider { get }
}

class CoreAssembly: ICoreAssembly {
    
    var coreDataStack: CoreDataStackProtocol = CoreDataStack()
    var conversationRequester: ConversationFetchRequesterProtocol = ConversationFetchRequester()
    var messageRequester: MessageFetchRequesterProtocol = MessageFetchRequester()
    lazy var requestSender: IRequestSender = RequestSender()
    lazy var imageDwnldrConfig = RequestsFactory.ImageLoaderFactory.imageDownloaderConfig()
    lazy var imageProvider: IImageProvider = ImageProvider.shared
}

