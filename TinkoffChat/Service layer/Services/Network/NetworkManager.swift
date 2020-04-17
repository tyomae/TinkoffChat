//
//  NetworkManager.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 17.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

protocol INetworkManager {
    associatedtype Parser: IParser
    typealias Model = Parser.Model
    var config: RequestConfig<Parser> { get }
    var requestSender: IRequestSender { get }
    func send()
}

protocol NetworkManagerDelegate: class {
    func modelDidLoad<Model>(model: Model)
    func handleError(description: String)
}

class NetworkManager<Parser: IParser> {
    
    typealias Model = Parser.Model
    var config: RequestConfig<Parser>
    var requestSender: IRequestSender
    weak var delegate: NetworkManagerDelegate?

    init(requestSender: IRequestSender, config: RequestConfig<Parser>) {
        self.config = config
        self.requestSender = requestSender
    }

    func send() {
        
        requestSender.send(config: config) { (result) in
            switch result {
            case .succes(let model):
                self.delegate?.modelDidLoad(model: model)
            case .error(let description):
                self.delegate?.handleError(description: description)
            }
        }
    }
}
