//
//  Creating.swift
//  Pods
//
//  Created by Julien Henrard on 2/05/16.
//
//

import Foundation
import CoreData

public class Creating {
    
    var managedContext : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    /**
     Fetch an entity in the managedContext.
     - returns: NSManagerObject
     - parameter entityName:     The name of the entity to create
     */
    public func entity(entityName: String) -> NSManagedObject{
        
        // On créée une entitée de type "Book" (un NSManagedObject). On récupere en premier, le type d'entitée, puis on créée un objet correspondant à cette entitée, et on l'insert dnas le managedContext
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedContext)
        let object = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        return object
        
        // On essaye de commit la modification, et on ajoute le book dans notre liste qui sert dataSource à notre table
        
    }
    
    public func exceptIfStringMatch(entityName: String, attributeName: String, attributeValue: String) -> NSManagedObject? {
        let results = CoreDataManager.Fetch.equalString(entityName, attributeName: attributeName, attributeValue: attributeValue)
        if results.count == 0 {
            return self.entity(entityName)
        }
        return nil
    }
    
    public func exceptIfIntMatch(entityName: String, attributeName: String, attributeValue: Int) -> NSManagedObject? {
        let results = CoreDataManager.Fetch.equalInt(entityName, attributeName: attributeName, attributeValue: attributeValue)
        if results.count == 0 {
            return self.entity(entityName)
        }
        return nil
    }
    
}