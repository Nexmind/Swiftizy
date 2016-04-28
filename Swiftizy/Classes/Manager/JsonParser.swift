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
    
    public static func jsonToManagedObject(dic: NSDictionary, createElseReturn entity: AnyClass, ignoreAttributes: [String]?) -> NSManagedObject {
        return self.consumeJsonAndCreateEntityInCoreData(dic, anyClass: entity, batchDescription: .CreateElseReturn, ignoreAttributes: ignoreAttributes)
        
    }
    
    public static func jsonToManagedObject(dic: NSDictionary, createElseUpdate entity: AnyClass, ignoreAttributes: [String]?) -> NSManagedObject {
        return self.consumeJsonAndCreateEntityInCoreData(dic, anyClass: entity, batchDescription: .CreateElseUpdate, ignoreAttributes: ignoreAttributes)
        
    }
    
    /*static func jsonToManagedObject(dic: NSDictionary, entity: AnyClass, relationshipDescription: JsonRelationshipDescription?, ignoreAttributes: [String]?) -> NSManagedObject{
        return self.consumeJsonAndCreateEntityInCoreData(dic, anyClass: entity, relationshipDescription: relationshipDescription, batchDescription: nil, ignoreAttributes: ignoreAttributes)
    }*/
    
    
    static func consumeJsonAndCreateEntityInCoreData(dic: NSDictionary, anyClass: AnyClass, batchDescription: JsonRelationshipDescriptionType?, ignoreAttributes: [String]?) -> NSManagedObject {
        
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
        
        for i in 0 ..< Int(propertyCount) {
            let property = properties[i]
            propertiesName.append(String(UTF8String: property_getName(property))!)
        }
        
        // 3. Treatment of all properties, add values from the Dictionary (JSON)
        for name in propertiesName {
            
            // Need to ignore ?
            if ignoreAttributes != nil && (ignoreAttributes?.contains(name))! {
                object.setValue(nil, forKey: name)
                
                // If not ignore so continue
            } else {
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
                                    object.setValue(self.consumeJsonAndCreateEntityInCoreData((dic[name] as! NSDictionary), anyClass: anyClass, batchDescription: batchDescription, ignoreAttributes: ignoreAttributes), forKey: name)
                                }
                                // Else, if TO-MANY
                            } else {
                                let arrayOfDic = dic[name] as! [NSDictionary]
                                let nameDest = descr.destinationEntity?.name!
                                let anyClass : NSManagedObject.Type = NSClassFromString(nameDest!) as! NSManagedObject.Type
                                let set = NSMutableSet()
                                for arrayItem in arrayOfDic {
                                    let descrObject = self.consumeJsonAndCreateEntityInCoreData((arrayItem), anyClass: anyClass, batchDescription: batchDescription, ignoreAttributes: ignoreAttributes)
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
                                        index += 1
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
                    if  batchDescription == .CreateElseReturn || batchDescription == nil{
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
                    } else if batchDescription == .CreateElseUpdate {
                        do {
                            var results = try CoreDataManager.managedContext.executeFetchRequest(fetchRequest)
                            if results.count == 0 {
                                object.setValue(dic[attributeName]!, forKey: name)
                            } else {
                                CoreDataManager.managedContext.deleteObject(object)
                                results[0].setValue(dic[attributeName], forKey: name)
                                self.updateObject(results[0] as! NSManagedObject, entity: entity!, propertiesName: propertiesName, dic: dic, batchDescription: batchDescription, ignoreAttributes: ignoreAttributes)
                                return results[0] as! NSManagedObject
                            }
                        } catch {
                                NSLog("---< !!! ERROR !!! >--- NexosPersistence (getObjectWithJson): Problem with the PK of entity '\(entityName)'. Verify in your entity if your primary key get the 'pk_' prefix.")
                        }
                    }
                }
            }
        }
        // 4. Return object
        return object
    }
    
    static func updateObject(var object: NSManagedObject, entity: NSEntityDescription, propertiesName: [String], dic: NSDictionary, batchDescription: JsonRelationshipDescriptionType?, ignoreAttributes: [String]?) {
        for name in propertiesName {
            // Need to ignore ?
            if ignoreAttributes != nil && (ignoreAttributes?.contains(name))! {
                object.setValue(nil, forKey: name)
                
                // If not ignore so continue
            } else {
                // It's a PK ? If No:
                if !InternalToolsForParser.attributeIsPK(name) {
                    if let _ = dic[name] {
                        // If property is a relationShip to other entity
                        if let descr = entity.propertiesByName[name] as? NSRelationshipDescription {
                            // If yes, check if TO-ONE
                            if !descr.toMany {
                                let nameDest = descr.destinationEntity?.name!
                                let anyClass : NSManagedObject.Type = NSClassFromString(nameDest!) as! NSManagedObject.Type
                                if !InternalToolsForParser.propertyIsNil(name, dic: dic) {
                                    object.setValue(self.consumeJsonAndCreateEntityInCoreData((dic[name] as! NSDictionary), anyClass: anyClass, batchDescription: batchDescription, ignoreAttributes: ignoreAttributes), forKey: name)
                                }
                                // Else, if TO-MANY
                            } else {
                                let arrayOfDic = dic[name] as! [NSDictionary]
                                let nameDest = descr.destinationEntity?.name!
                                let anyClass : NSManagedObject.Type = NSClassFromString(nameDest!) as! NSManagedObject.Type
                                let set = NSMutableSet()
                                for arrayItem in arrayOfDic {
                                    let descrObject = self.consumeJsonAndCreateEntityInCoreData((arrayItem), anyClass: anyClass, batchDescription: batchDescription, ignoreAttributes: ignoreAttributes)
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
                                        index += 1
                                    }
                                    object.setValue(string, forKey: name)
                                } else {
                                    object.setValue(dic[name]!, forKey: name)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
