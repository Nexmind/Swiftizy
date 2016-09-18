//
//  Deleting.swift
//  Pods
//
//  Created by Julien Henrard on 2/05/16.
//
//

import Foundation
import CoreData

@available(iOS 10.0, *)
public class Deleting {
    
    var managedContext : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    public func batch(entity : AnyClass){
        let request: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }
    
    public func one(entity: NSManagedObject){
        self.managedContext.delete(entity)
    }
    
    public func many(objects: [NSManagedObject]){
        for object in objects {
            self.managedContext.delete(object)
        }
    }
    
    

}
