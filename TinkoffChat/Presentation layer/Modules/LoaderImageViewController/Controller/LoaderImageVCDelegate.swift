//
//  LoaderImageVCDelegate.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 17.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import UIKit


extension LoaderImageViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? DownloadImageCollectionViewCell else { return }
        if cell.imageUpload {
            performSegue(withIdentifier: "UnwindToProfile", sender: cell.downloadImage.image)
        } else {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
