//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 28/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class StorageManager {
    
    var coreDataStack: CoreDataStack = CoreDataStack()
    
    func getProfile(in context: NSManagedObjectContext) -> AppUser? {
        
        var appUser : AppUser?
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert(false)
            return nil
        }
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser: \(error)")
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        return appUser
    }
    
    func saveAppUser(name: String?, info: String?, photo: UIImage?, completionHandler: @escaping ((String?)->Void)) {
        
        let appUser = self.getProfile(in: coreDataStack.masterContext)

        if (appUser != nil) {
            if let name = name {
                appUser!.name = name
            }
            if let info = info {
                appUser!.info = info
            }
            if let photo = photo {
                if let imageData = photo.jpegData(compressionQuality: 1.0) {
                    let imageNSData : NSData = imageData as NSData
                    appUser!.photo = imageNSData
                } else {
                    completionHandler("Can't save photo")
                    print("Can't save photo")
                    return
                }
            }
            self.coreDataStack.performSave(context: self.coreDataStack.masterContext, completionHandler: completionHandler)
        } else {
            completionHandler("Can't find or insert AppUser")
            print("Can't find or insert AppUser")
        }
    }
    
    func loadAppUser() -> AppUser? {
        return self.getProfile(in: self.coreDataStack.saveContext)
    }
}
