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
    
    var managedContext : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    /**
     Fetch an entity in the managedContext.
     - returns: NSManagerObject
     - parameter entityName:     The name of the entity to create
     */
    public func entity(entity: String) -> NSManagedObject{
        
        // On créée une entitée de type "Book" (un NSManagedObject). On récupere en premier, le type d'entitée, puis on créée un objet correspondant à cette entitée, et on l'insert dnas le managedContext
        let entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)
        let object = NSManagedObject(entity: entity!, insertInto: managedContext)
        return object
        
        // On essaye de commit la modification, et on ajoute le book dans notre liste qui sert dataSource à notre table
        
    }
    
    public func exceptIfStringMatch(entity: AnyClass, attributeName: String, attributeValue: String) -> NSManagedObject? {
        let results = CoreDataManager.Fetch.equalString(entity: entity, attributeName: attributeName, attributeValue: attributeValue)
        if results.count == 0 {
            return self.entity(entity: NSStringFromClass(entity).pathExtension)
        }
        return nil
    }
    
    public func exceptIfIntMatch(entity: AnyClass, attributeName: String, attributeValue: Int) -> NSManagedObject? {
        let results = CoreDataManager.Fetch.equalInt(entity: entity, attributeName: attributeName, attributeValue: attributeValue)
        if results.count == 0 {
            return self.entity(entity: NSStringFromClass(entity).pathExtension)
        }
        return nil
    }
    
}
