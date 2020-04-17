//
//  LoaderImageVCDataSource.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 17.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import UIKit

extension LoaderImageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageLoaderInteractor.imageRequestsStorage?.imagesURL.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DownloadImageCell",
                                                            for: indexPath) as?
            DownloadImageCollectionViewCell else { return UICollectionViewCell() }
        let imageRequest = imageLoaderInteractor.imageRequestsStorage!.imagesURL[indexPath.row]
        guard let imageUrl = imageRequest.url else { return cell }
        cell.url = imageUrl
        imageLoaderInteractor.uploadImage(url: imageUrl) { (data) in
            if let data = data, let image = UIImage(data: data), imageUrl == cell.url {
                DispatchQueue.main.async {
                    cell.downloadImage.image = image
                    cell.imageUpload = true
                }
            }
        }
        return cell
    }
}
