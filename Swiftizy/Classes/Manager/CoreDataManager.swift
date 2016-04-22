//
//  CoreDataManager.swift
//  Nexos_demo
//
//  Created by Julien Henrard on 25/11/15.
//  Copyright © 2015 NexMind. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class CoreDataManager {
    
    public static var managedContext : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    // TODO: Faire une putain de méthode qui gère le versionning de la BD LOCALE
    
    /**
     Fetch an entity in the managedContext.
     - returns: [NSManagerObject]
     - parameter entityName:     The name of the entity to fetch
     */
    public static func fetchForEntity(entityName : String) -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            return results as! [NSManagedObject]

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
    }
    
    public static func countEntity(entityName : String) -> Int {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            return results.count
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return 0
        }
    }
    
    public static func countEntityWithPredicate(entity: String, predicate: NSPredicate) -> Int{
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.predicate = predicate
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results.count
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return 0
        }
    }
    
    public static func fetchForEntityOrderAscending(entityName : String, orderBy : String) -> [NSManagedObject]{
        let descriptor = NSSortDescriptor(key: orderBy, ascending: true)
        
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
    
    public static func fetchEntityWithMultipleDescriptorAndPredicate(entityName : String, descriptors : [NSSortDescriptor], predicate : NSPredicate) -> [NSManagedObject]{
        
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
    
    /**
     Fetch an entity in the managedContext with a predicate
     - returns: [NSManagerObject]
     - parameter entityName:     The name of the entity
     - parameter attributeName:     Name of the attribute to modify
     - parameter attributeValue:     The new value of the attribute
     */
    public static func fetchWithPredicateWithString(entityName : String, attributeName : String, attributeValue: String) -> [NSManagedObject]{
        
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
    
    public static func fetchWithCustomPredicate(entityName : String, predicate : NSPredicate) -> [NSManagedObject]{

        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        do{
            if let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                return fetchResults
            }
        } catch let error as NSError {
            print("Could not fetch predicate \(error), \(error.userInfo)")
        }
        return []
    }
    
    /**
     Fetch an entity in the managedContext with a predicate by ID (Int)
     - returns: [NSManagerObject]
     - parameter entityName:     The name of the entity
     - parameter attributeName:     Name of the attribute to modify
     - parameter attributeValue:     The new value of the attribute
     */
    public static func fetchWithPredicateWithInt(entityName : String, attributeName : String, id: Int) -> [NSManagedObject]{

        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(attributeName) = %d", id)
        do{
            if let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                return fetchResults
            }
        } catch let error as NSError {
            print("Could not fetch predicate \(error), \(error.userInfo)")
        }
        return []
    }
    
    public static func fetchWithPredicateWithBool(entityName : String, attributeName : String, bool: Bool) -> [NSManagedObject] {
    
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
    
    /**
     Fetch an entity in the managedContext.
     - returns: NSManagerObject
     - parameter entityName:     The name of the entity to create
     */
    public static func createEntity(entityName: String) -> NSManagedObject{
        
        // On créée une entitée de type "Book" (un NSManagedObject). On récupere en premier, le type d'entitée, puis on créée un objet correspondant à cette entitée, et on l'insert dnas le managedContext
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedContext)
        let object = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        return object
        
        // On essaye de commit la modification, et on ajoute le book dans notre liste qui sert dataSource à notre table

    }
    
    public static func createEntityIfExistWithStringComparator(entityName: String, attributeName: String, attributeValue: String) -> NSManagedObject? {
        let results = CoreDataManager.fetchWithPredicateWithString(entityName, attributeName: attributeName, attributeValue: attributeValue)
        if results.count == 0 {
            return CoreDataManager.createEntity(entityName)
        }
        return nil
        
    }
    
    /**
     Fetch an entity in the managedContext.
     - returns: [NSManagerObject]
     - parameter entityName:     The name of the entity to fetch
     */
    
    @available(iOS 9.0, *)
    public static func batchDeleteEntity(entityName : String){
        dispatch_async(dispatch_get_main_queue()) {
            let fetchRequest = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedContext.executeRequest(deleteRequest)
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
        }
    }
    
    @available(iOS 9.0, *)
    public static func batchDeleteEntityCurrentThread(entityName : String){
            let fetchRequest = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedContext.executeRequest(deleteRequest)
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
    }
    
    public static func deleteOneEntity(entity: NSManagedObject){

        managedContext.deleteObject(entity)
    }
    
    public static func deleteSomeEntity(objects: [NSManagedObject]){
        for object in objects {
            self.managedContext.deleteObject(object)
        }
    }
    
    /**
     Save the context after modifications
     */
    public static func save(){
        do{
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    /**
     Reset the context
     */
    public static func reset() {
        do {
            try managedContext.reset()
        } catch let error as NSError {
            print("Could not reset \(error), \(error.userInfo)")
        }
    }
    
    /**
     Discard changes in the context since the last save
     */
    public static func discardChanges() {
        do {
            try managedContext.rollback()
        } catch let error as NSError {
            print("Could not reset \(error), \(error.userInfo)")
        }
    }
}
