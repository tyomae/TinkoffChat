//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 28/03/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
    
    func performSave(context: NSManagedObjectContext, completionHandler : ((String?) -> Void)?)
    var mainContext: NSManagedObjectContext { get }
    var saveContext: NSManagedObjectContext { get }
}

class CoreDataStack: CoreDataStackProtocol {
    
    static let shared = CoreDataStack()
    private lazy var storeURL: URL = {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent("CoreDataModel.sqlite")
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "CoreDataModel",
                                             withExtension: "momd") else { fatalError("Can't search the resource") }
        guard let objectModel = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("Can't search the object model by this url: \(modelURL)") }
        return objectModel
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: storeURL,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                         NSInferMappingModelAutomaticallyOption: true])
        } catch {
            assert(false, "Error adding store: \(error)")
        }
        return coordinator
    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        saveContext.undoManager = nil
        return saveContext
    }()
    
    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        masterContext.undoManager = nil
        return masterContext
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        mainContext.undoManager = nil
        return mainContext
    }()
    
    public func performSave(context: NSManagedObjectContext, completionHandler : ((String?) -> Void)?) {
        
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                }
                catch {
                    print("Context save error: \(error)")
                    completionHandler?("Context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self.performSave(context: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?(nil)
                }
            }
            else  {
                completionHandler?(nil)
            }
        }
    }
}
