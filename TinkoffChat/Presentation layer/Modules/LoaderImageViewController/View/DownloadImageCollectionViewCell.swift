//
//  DownloadImageCollectionViewCell.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 17.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class DownloadImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var downloadImage: UIImageView! {
        didSet{
             downloadImage.layer.cornerRadius = 10
        }
    }
    
    var url: URL!
    var imageUpload: Bool = false
}
