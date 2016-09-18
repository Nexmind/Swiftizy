//
//  Fetch.swift
//  Pods
//
//  Created by Julien Henrard on 1/05/16.
//
//

import Foundation
import CoreData

@available(iOS 10.0, *)
public class Fetching {
    
    var managedContext : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    /**
     Find all for the entity
     */
    public func all(entity: AnyClass) -> [NSManagedObject]{
        let request: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        
        do {
            let results =
                try self.managedContext.fetch(request)
            return results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
    }
    
    /**
    Find all and order by
    */
    public func orderBy(entity : AnyClass, orderBy : String, ascending: Bool) -> [NSManagedObject]{
        let descriptor = NSSortDescriptor(key: orderBy, ascending: ascending)
        
        let request: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        request.sortDescriptors = [descriptor]
        
        do {
            let results =
                try managedContext.fetch(request)
            return results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
    }
    
    public func custom(entity : AnyClass, descriptors : [NSSortDescriptor]?, predicate : NSPredicate?) -> [NSManagedObject]{
        
        let request: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        request.sortDescriptors = descriptors
        request.predicate = predicate
        do {
            let results =
                try managedContext.fetch(request)
            return results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
    }
    
    public func equalString(entity : AnyClass, attributeName : String, attributeValue: String) -> [NSManagedObject]{
        
        let request: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        request.predicate = NSPredicate(format: "\(attributeName) == %@", attributeValue)
        do{
            if let fetchResults = try managedContext.fetch(request) as? [NSManagedObject] {
                return fetchResults
            }
        } catch let error as NSError {
            print("Could not fetch predicate \(error), \(error.userInfo)")
        }
        return []
    }
    
    public func equalInt(entity : AnyClass, attributeName : String, attributeValue: Int) -> [NSManagedObject]{
        
        let request: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        request.predicate = NSPredicate(format: "\(attributeName) = %d", attributeValue)
        do{
            if let fetchResults = try managedContext.fetch(request) as? [NSManagedObject] {
                return fetchResults
            }
        } catch let error as NSError {
            print("Could not fetch predicate \(error), \(error.userInfo)")
        }
        return []
    }
    
    public func equalBool(entity : AnyClass, attributeName : String, bool: Bool) -> [NSManagedObject] {
        
        let request: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        request.predicate = NSPredicate(format: "\(attributeName) = \(bool)")
        do{
            if let fetchResults = try managedContext.fetch(request) as? [NSManagedObject] {
                return fetchResults
            }
        } catch let error as NSError {
            print("Could not fetch predicate \(error), \(error.userInfo)")
        }
        return []
    }
}
