//
//  Counting.swift
//  Pods
//
//  Created by Julien Henrard on 2/05/16.
//
//

import Foundation
import CoreData

public class Counting {

    var managedContext : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    public func all(entityName: String) -> Int {
        let request: NSFetchRequest = NSFetchRequest()
        let description = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.managedContext)
        request.entity = description
        request.includesSubentities = false
        
        let err: NSErrorPointer = nil;
        let count: Int = self.managedContext.countForFetchRequest(request, error: err)
        if(count == NSNotFound) {
            return 0
        }
        return count
    }
    
    public func custom(entityName: String, predicate: NSPredicate) -> Int{
        let request: NSFetchRequest = NSFetchRequest()
        let description = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.managedContext)
        request.entity = description
        request.predicate = predicate
        request.includesSubentities = false
        
        let err: NSErrorPointer = nil;
        let count: Int = self.managedContext.countForFetchRequest(request, error: err)
        if(count == NSNotFound) {
            return 0
        }
        return count
    }
}