//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 14/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class UserInfo {
    
    var userName : String?
    var userDescription : String?
    var userPhoto : UIImage?
    
    var fileName: String {
        return "UserInfo.txt"
    }
    var photoName: String {
        return "UserPhoto.jpeg"
    }
}

class DataManager {
    
    static func savePhoto(userPhoto: UIImage?, photoName: String) throws {
        
        let tempDir = NSTemporaryDirectory()
        let path = (tempDir as NSString).appendingPathComponent(photoName)
        
        if let image = userPhoto, let imageData = image.jpegData(compressionQuality: 1.0) {
            let imageNSData: NSData = imageData as NSData
            try imageNSData.write(toFile: path, options: [])
        }
    }
    
    static func saveTextData(userName: String?, userDescription: String?, fileName: String) throws {
        
        let tempDir = NSTemporaryDirectory()
        let path = (tempDir as NSString).appendingPathComponent(fileName)
        let fileManager = FileManager.default
        var fileText: String
        if (!fileManager.fileExists(atPath: path)) {
            fileText = userName ?? "Name"
            fileText.append("\n")
            fileText.append(userDescription ?? "About me")
        } else {
            fileText = try String(contentsOfFile: path, encoding: .utf8)
            var fileLines = fileText.components(separatedBy: .newlines)
            if let userName = userName {
                fileLines[0] = userName
            }
            if let userDescription = userDescription {
                fileLines[1] = userDescription
            }
            fileText = fileLines.joined(separator: "\n")
        }
        try fileText.write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    static func loadData(fileName: String, photoName: String) throws -> (name: String?, description: String?, image: UIImage?) {
        let tempDir = NSTemporaryDirectory()
        var path = (tempDir as NSString).appendingPathComponent(photoName)
        let fileManager = FileManager.default
        let userPhoto = UIImage(contentsOfFile: path)
        path = (tempDir as NSString).appendingPathComponent(fileName)
        if (!fileManager.fileExists(atPath: path)) {
            return (name: nil, description: nil, image: userPhoto)
        }
        let fileText = try String(contentsOfFile: path, encoding: .utf8)
        let fileLines = fileText.components(separatedBy: .newlines)
        return (name: fileLines[0], description: fileLines[1], image: userPhoto)
    }
}



