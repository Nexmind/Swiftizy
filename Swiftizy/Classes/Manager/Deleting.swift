//
//  Deleting.swift
//  Pods
//
//  Created by Julien Henrard on 2/05/16.
//
//

import Foundation
import CoreData

public class Deleting {
    
    var managedContext : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    @available(iOS 9.0, *)
    public func batch(entityName : String){
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.executeRequest(deleteRequest)
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }
    
    public func one(entity: NSManagedObject){
        self.managedContext.deleteObject(entity)
    }
    
    public func many(objects: [NSManagedObject]){
        for object in objects {
            self.managedContext.deleteObject(object)
        }
    }
    
    

}