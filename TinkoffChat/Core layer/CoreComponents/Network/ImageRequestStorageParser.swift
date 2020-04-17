//
//  ImageRequestStorageParser.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 17.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

struct ImageRequestsStorageParser: IParser {
    
    typealias Model = ImageRequestsStorage

    func parse(data: Data) -> ImageRequestsStorage? {
        
        let jsonDecoder = JSONDecoder()
        let imageDownloader = try? jsonDecoder.decode(ImageRequestsStorage.self, from: data)
        return imageDownloader
    }
}
