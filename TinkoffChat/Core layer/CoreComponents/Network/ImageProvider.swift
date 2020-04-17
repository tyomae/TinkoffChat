//
//  ImageProvider.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 17.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

typealias IImageProvider = IDataProvider & IImageDownloader

protocol IDataProvider {
    var dataCache: NSCache<NSString, NSData> { get }
}

protocol IImageDownloader {
    func downloadImage(url: URL, completion: @escaping (RequestResult<Data>) -> Void)
}

class ImageProvider: IImageProvider {
    
    static var shared = ImageProvider()
    var dataCache: NSCache<NSString, NSData> = NSCache<NSString, NSData>()

    func downloadImage(url: URL, completion: @escaping (RequestResult<Data>) -> Void) {
        if let data = dataCache.object(forKey: url.absoluteString as NSString) {
            completion(RequestResult<Data>.succes(data as Data))
        }

        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(RequestResult<Data>.error(error.localizedDescription))
            }

            if let data = data {
                completion(RequestResult<Data>.succes(data as Data))
                self.dataCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
            }
        }
        dataTask.resume()
    }
}
