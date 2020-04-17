//
//  LoaderImagerInteractor.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 17.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

protocol IImageLoaderInteractor: class {
    var delegate: ImageLoaderDelegate? { get set }
    var imageRequestsStorage: IImageRequestsStorage? { get set }
    func loadImageURLs()
    func uploadImage(url: URL, completionImageHandler: @escaping (Data?) -> Void)
}

protocol ImageLoaderDelegate: class {
    func updateImages()
    func handleEror()
}

class ImageLoaderInteractor: IImageLoaderInteractor, NetworkManagerDelegate {

    weak var delegate: ImageLoaderDelegate?
    var imageRequestsStorage: IImageRequestsStorage?
    var imageDownloadManager: IImageDownloadManager
    private var networkManager: NetworkManager<ImageRequestsStorageParser>

    init(networkManager: NetworkManager<ImageRequestsStorageParser>, imageDownloadManager: IImageDownloadManager) {
        self.imageDownloadManager = imageDownloadManager
        self.networkManager = networkManager
        self.networkManager.delegate = self
    }

    func loadImageURLs() {
        networkManager.send()
    }

    func uploadImage(url: URL, completionImageHandler: @escaping (Data?) -> Void) {
        imageDownloadManager.send(url: url, completionImageHandler: completionImageHandler)
    }

    func modelDidLoad<Model>(model: Model) {
        guard let imageStorage = model as? IImageRequestsStorage else { return }
        self.imageRequestsStorage = imageStorage
        DispatchQueue.main.async {
            self.delegate?.updateImages()
        }
    }

    func handleError(description: String) {
        DispatchQueue.main.async {
            self.delegate?.handleEror()
        }
    }
}
