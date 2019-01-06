//
//  DataBaseManager.swift
//  TestProject
//
//  Created by Yogesh on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import CoreData

class DataBaseManager: NSObject {
   static let sharedManager  = DataBaseManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TestProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        if Thread.isMainThread == true  {
            saveDbChanges()
        } else{
            DispatchQueue.main.sync {
                saveDbChanges()
            }
        }
    }
    
    //Article
    // MARK: - Core Data Saving support
    private func saveDbChanges () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// Make Entity by passing entity name
    private func insertEntity(entityName : String) -> AnyObject {
        let viewContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName:entityName, in: viewContext)
        let entityObj = NSManagedObject(entity: entity!, insertInto: viewContext)
        return entityObj
    }

    
    
    /// Get Entity By Name
    func getEntityByName(entityName : String,
                                     batchNum: Int = 0,
                                     batchSize: Int = 0,
                                     batchOffset: Int = 0,
                                     predicate : NSPredicate?,
                                     sortDescriptors : [NSSortDescriptor]? = nil) -> Array<NSManagedObject>? {
        // DispatchQueue.main.sync {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.fetchBatchSize = batchSize
        request.fetchLimit = batchNum
        request.fetchOffset = batchOffset
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do {
            let result = try persistentContainer.viewContext.fetch(request) as? [NSManagedObject]
            if let entityStorage  = result {
                if entityStorage.isEmpty == false {
                    return entityStorage
                }
            }
            
        } catch {
            
        }
        return nil
    }
    
    private func deleteAllEntitiesRelatedWithName(entityName : String, predicate : NSPredicate?) {
        let fetch        = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetch.predicate  = predicate
        let request      = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            _ = try persistentContainer.viewContext.execute(request)
        } catch{
        }
    }
    
    

}
