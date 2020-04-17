//
//  RequestConfiguration.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 17.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

protocol IRequest {
    
    var urlRequest: URLRequest? { get }
}

protocol IParser {
    
    associatedtype Model
    func parse(data: Data) -> Model?
}

enum RequestResult<T> {
    
    case succes(T)
    case error(String)
}

struct RequestConfig<Parser: IParser> {
    
    var request: IRequest
    var parser: Parser
}
