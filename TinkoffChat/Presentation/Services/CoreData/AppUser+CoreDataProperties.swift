//
//  AppUser+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 28/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//
import Foundation
import CoreData


extension AppUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: "AppUser")
    }

    @NSManaged public var name: String?
    @NSManaged public var info: String?
    @NSManaged public var photo: NSData?

}
