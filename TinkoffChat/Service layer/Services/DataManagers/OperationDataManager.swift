//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 14/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import UIKit

class OperationDataManager  {
    
    func saveData(userInfo: UserInfo, completion: @escaping (Error?) -> ()) {
        
        print("Operation save")

        let operationSave = SavingOperation(userInfo: userInfo)
        operationSave.qualityOfService = .userInitiated
        operationSave.completionBlock = {
            OperationQueue.main.addOperation {
                completion(operationSave.error)
            }
        }
        let saveQueue = OperationQueue()
        saveQueue.addOperation(operationSave)
    }
    
    func loadData(completion: @escaping (UserInfo?, Error?) -> ()) {
        
        print("Operation load")
        
        let operationLoad = LoadingOperation()
        operationLoad.qualityOfService = .userInitiated
        operationLoad.completionBlock = {
            OperationQueue.main.addOperation {
                completion(operationLoad.userInfo, operationLoad.error)
            }
        }
        let saveQueue = OperationQueue()
        saveQueue.addOperation(operationLoad)
    }
}

class SavingOperation: AsyncOperation {
    
    let userInfo: UserInfo
    var error : Error?
    
    init(userInfo: UserInfo) {
        
        self.userInfo = userInfo
        
        super.init()
    }
    
    override func main() {
        self.error = nil
        do {
            try DataManager.savePhoto(userPhoto: userInfo.userPhoto, photoName: userInfo.photoName)
            try DataManager.saveTextData(userName: userInfo.userName, userDescription: userInfo.userDescription, fileName: userInfo.fileName)
        } catch let error {
            self.error = error
        }
        self.state = .finished
    }
}

class LoadingOperation: AsyncOperation {
    
    var userInfo: UserInfo?
    var error : Error?
    
    override func main() {
        self.error = nil
        do {
            let userInfo = UserInfo()
            let userData = try DataManager.loadData(fileName: userInfo.fileName, photoName: userInfo.photoName)
            userInfo.userName = userData.name
            userInfo.userDescription = userData.description
            userInfo.userPhoto = userData.image
            self.userInfo = userInfo
        } catch let error {
            self.error = error
        }
        self.state = .finished
    }
}

