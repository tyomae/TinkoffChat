//
//  AppUser.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 28/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import CoreData

public class AppUser: NSManagedObject {
    
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        if let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser",
                                                             into: context) as? AppUser {
            return appUser
        }
        return nil
    }
}

extension AppUser {
    
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest
    }
}

