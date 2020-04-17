//
//  Requests.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 17.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

struct PixabayRequest: IRequest {
    
    var urlRequest: URLRequest?

    init(apiKey: String) {
        var urlString = "https://pixabay.com/api/"
        urlString += ("?key=" + apiKey)
        let url = URL(string: urlString)!
        urlRequest = URLRequest(url: url)
        print(url.absoluteString)
    }
}
