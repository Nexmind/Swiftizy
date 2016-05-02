//
//  Fetch.swift
//  Pods
//
//  Created by Julien Henrard on 1/05/16.
//
//

import Foundation
import CoreData

public class Fetching {
    
    var managedContext : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    /**
     Find all for the entity
     */
    public func all(entityName: String) -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        do {
            let results =
                try self.managedContext.executeFetchRequest(fetchRequest)
            return results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
    }
    
    /**
    Find all and order by
    */
    public func orderBy(entityName : String, orderBy : String, ascending: Bool) -> [NSManagedObject]{
        let descriptor = NSSortDescriptor(key: orderBy, ascending: ascending)
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.sortDescriptors = [descriptor]
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            return results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
    }
    
    public func custom(entityName : String, descriptors : [NSSortDescriptor]?, predicate : NSPredicate?) -> [NSManagedObject]{
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.sortDescriptors = descriptors
        fetchRequest.predicate = predicate
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            return results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
    }
    
    public func equalString(entityName : String, attributeName : String, attributeValue: String) -> [NSManagedObject]{
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(attributeName) == %@", attributeValue)
        do{
            if let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                return fetchResults
            }
        } catch let error as NSError {
            print("Could not fetch predicate \(error), \(error.userInfo)")
        }
        return []
    }
    
    public func equalInt(entityName : String, attributeName : String, attributeValue: Int) -> [NSManagedObject]{
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(attributeName) = %d", attributeValue)
        do{
            if let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                return fetchResults
            }
        } catch let error as NSError {
            print("Could not fetch predicate \(error), \(error.userInfo)")
        }
        return []
    }
    
    public func equalBool(entityName : String, attributeName : String, bool: Bool) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(attributeName) = \(bool)")
        do{
            if let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                return fetchResults
            }
        } catch let error as NSError {
            print("Could not fetch predicate \(error), \(error.userInfo)")
        }
        return []
    }
}