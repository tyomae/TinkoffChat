//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 14/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager: UserDataManager {
    
    func saveData(userInfo: UserInfo, completion: @escaping (Error?) -> ()) {
        
        print("GCD save")

        let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
        userInitiatedQueue.async {
            do {
                try DataManager.savePhoto(userPhoto: userInfo.userPhoto, photoName: userInfo.photoName)
                try DataManager.saveTextData(userName: userInfo.userName, userDescription: userInfo.userDescription, fileName: userInfo.fileName)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let error {
                DispatchQueue.main.async { completion(error) }
            }
        }
    }
    
    func loadData(completion: @escaping (UserInfo?, Error?) -> ()) {
        
        print("GCD load")

        let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
        userInitiatedQueue.async {
            do {
            
                let userInfo = UserInfo()
                let userData = try DataManager.loadData(fileName: userInfo.fileName, photoName: userInfo.photoName)
                
                userInfo.userName = userData.name
                userInfo.userDescription = userData.description
                userInfo.userPhoto = userData.image
                DispatchQueue.main.async {
                    completion(userInfo, nil)
                }
            } catch let error {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
    }
}
