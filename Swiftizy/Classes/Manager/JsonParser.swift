//
//  NexORM.swift
//  SandwichsViewer
//
//  Created by Julien Henrard on 16/01/16.
//  Copyright © 2016 NexMind. All rights reserved.
//

import Foundation
import CoreData

public class JsonParser {
    
    
    /**
     Consume some JSON and parse IT in a subclass of NSManagedObject. So the NSManagedObject and his relationship are create in the core data if they dont. If they are, return existing.
     - returns: NSManagedObject added in the context
     - parameter dic:   the NSDictionary that contains the JSON
     - parameter anyClass:   the class of the entity.
     */
    public static func consumeJsonAndCreateEntityInCoreData(dic: NSDictionary, anyClass: AnyClass) -> NSManagedObject {
        
        // 1. Get entity and init dynamicly the object
        let entityName = NSStringFromClass(anyClass)
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: CoreDataManager.managedContext)
        
        let clz: NSManagedObject.Type = anyClass as! NSManagedObject.Type
        let object = clz.init(entity: entity!,
            insertIntoManagedObjectContext: CoreDataManager.managedContext)
        
        // 2. Reflect the object to get name of each property
        var propertyCount : UInt32 = 0
        let properties = class_copyPropertyList(clz.self, &propertyCount)
        var propertiesName : [String] = [String]()
        
        for var i=0; i < Int(propertyCount); i++ {
            let property = properties[i]
            propertiesName.append(String(UTF8String: property_getName(property))!)
        }
        
        // 3. Treatment of all properties, add values from the Dictionary (JSON)
        for name in propertiesName {
            // It's a PK ? If No:
            if !InternalToolsForParser.attributeIsPK(name) {
                if let _ = dic[name] {
                    // If property is a relationShip to other entity
                    if let descr = entity!.propertiesByName[name] as? NSRelationshipDescription {
                        // If yes, check if TO-ONE
                        if !descr.toMany {
                            let nameDest = descr.destinationEntity?.name!
                            let anyClass : NSManagedObject.Type = NSClassFromString(nameDest!) as! NSManagedObject.Type
                            if !InternalToolsForParser.propertyIsNil(name, dic: dic) {
                                object.setValue(self.consumeJsonAndCreateEntityInCoreData((dic[name] as! NSDictionary), anyClass: anyClass), forKey: name)
                            }
                            // Else, if TO-MANY
                        } else {
                            let arrayOfDic = dic[name] as! [NSDictionary]
                            let nameDest = descr.destinationEntity?.name!
                            let anyClass : NSManagedObject.Type = NSClassFromString(nameDest!) as! NSManagedObject.Type
                            let set = NSMutableSet()
                            for arrayItem in arrayOfDic {
                                let descrObject = self.consumeJsonAndCreateEntityInCoreData((arrayItem), anyClass: anyClass)
                                set.addObject(descrObject)
                            }
                            object.setValue((set as NSSet), forKey: name)
                        }
                        
                        // If is primitive value
                    } else {
                        if !InternalToolsForParser.propertyIsNil(name, dic: dic){
                            if let array = dic[name]! as? NSArray {
                                var string = ""
                                var index = 1
                                for item in array {
                                    if index == array.count{
                                        string += item.description
                                    } else {
                                        string += item.description + ","
                                    }
                                    index++
                                }
                                object.setValue(string, forKey: name)
                            } else {
                                object.setValue(dic[name]!, forKey: name)
                            }
                        }
                    }
                }
                
                // If Yes It's a PK:
            } else {
                let attributeName = InternalToolsForParser.getPkAttributeName(name)
                var predicate = NSPredicate()
                if let number = dic[attributeName]! as? NSNumber {
                    predicate = NSPredicate(format: "\(name) = %@", number)
                }
                
                if let string = dic[attributeName]! as? String {
                    predicate = NSPredicate(format: "\(name) = %@", string)
                }
                
                let fetchRequest = NSFetchRequest(entityName: entityName)
                fetchRequest.predicate = predicate
                do {
                    let results = try CoreDataManager.managedContext.executeFetchRequest(fetchRequest)
                    if results.count == 0 {
                        object.setValue(dic[attributeName]!, forKey: name)
                    } else {
                        CoreDataManager.managedContext.deleteObject(object)
                        return results[0] as! NSManagedObject
                    }
                } catch {
                    NSLog("---< !!! ERROR !!! >--- NexosPersistence (getObjectWithJson): Problem with the PK of entity '\(entityName)'. Verify in your entity if your primary key get the 'pk_' prefix.")
                }
                
            }
        }
        // 4. Return object
        return object
    }
}
