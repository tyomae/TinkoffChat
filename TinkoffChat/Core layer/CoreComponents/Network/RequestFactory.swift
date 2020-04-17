//
//  RequestFactory.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 17.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    struct ImageLoaderFactory {
        
        static func imageDownloaderConfig() -> RequestConfig<ImageRequestsStorageParser> {
            return RequestConfig<ImageRequestsStorageParser>(request:
                PixabayRequest(apiKey: "16090113-85d39409ad65f039aa30550f8"),
                                                        parser: ImageRequestsStorageParser())
        }
    }
}
