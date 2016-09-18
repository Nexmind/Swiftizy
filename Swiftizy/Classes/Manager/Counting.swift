//
//  Counting.swift
//  Pods
//
//  Created by Julien Henrard on 2/05/16.
//
//

import Foundation
import CoreData

@available(iOS 10.0, *)
public class Counting {
    
    var managedContext : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    public func all(entity: AnyClass) -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        request.includesSubentities = false
        do {
            let count: Int = try self.managedContext.count(for: request)
            if(count == NSNotFound) {
                return 0
            }
            return count
        } catch {
            return 0
        }
        
    }
    
    public func custom(entity: AnyClass, predicate: NSPredicate) -> Int{
        let request: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        request.predicate = predicate
        request.includesSubentities = false
        
        do {
            let count: Int = try self.managedContext.count(for: request)
            if(count == NSNotFound) {
                return 0
            }
            return count
        } catch {
            return 0
        }
    }
}
