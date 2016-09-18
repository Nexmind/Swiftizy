//
//  ManagedParser.swift
//  Crunchizy
//
//  Created by Julien Henrard on 17/01/16.
//  Copyright © 2016 NexMind. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 9.0, *)
public class ObjectParser: NSObject {
    
    
    public class func convertToArray(managedObjects:NSArray?, ignoreAttributes: [String]?, parentNode:String? = nil) -> NSArray {
        
        let rtnArr:NSMutableArray = NSMutableArray();
        //--
        if let managedObjs:[NSManagedObject] = managedObjects as? [NSManagedObject] {
            for managedObject:NSManagedObject in managedObjs {
                rtnArr.add(self.convertToDictionary(managedObject: managedObject,ignoreAttributes: ignoreAttributes, parentNode: parentNode));
            }
        }
        
        return rtnArr;
    } //F.E.
    
    public class func convertToDictionary(managedObject:NSManagedObject, ignoreAttributes: [String]?, parentNode:String? = nil) -> NSDictionary {
        
        let rtnDict:NSMutableDictionary = NSMutableDictionary();
        //-
        let entity:NSEntityDescription = managedObject.entity;
        var properties:[String] = (entity.propertiesByName as NSDictionary).allKeys as! [String];
        if ignoreAttributes != nil {
            for attribute in ignoreAttributes! {
                if properties.contains(attribute) {
                    properties.remove(at: properties.index(of: attribute)!)
                }
            }
        }
        //--
        let parentNode:String = parentNode ?? managedObject.entity.name!;
        for property:String in properties  {
            var currentProperty = property
            if InternalToolsForParser.attributeIsPK(name: property) {
                currentProperty = InternalToolsForParser.getPkAttributeName(name: property)
            }
            if (currentProperty.caseInsensitiveCompare(parentNode) != ComparisonResult.orderedSame)
            {
                let value: AnyObject? = managedObject.value(forKey: property) as AnyObject?;
                //--
                if let set:NSSet = value as? NSSet  {
                    rtnDict[currentProperty] = self.convertToArray(managedObjects: set.allObjects as NSArray?, ignoreAttributes: nil, parentNode: parentNode);
                } else if let vManagedObject:NSManagedObject = value as? NSManagedObject {
                    
                    if (vManagedObject.entity.name != parentNode) {
                        rtnDict[currentProperty] = self.convertToDictionary(managedObject: vManagedObject, ignoreAttributes: nil,parentNode: parentNode);
                    }
                } else  if let vData:AnyObject = value {
                    rtnDict[currentProperty] = vData;
                }
            }
        }
        
        return rtnDict;
    } //F.E.
    
    public class func convertToJsonString(managedObject:NSManagedObject, ignoreAttributes: [String]?) -> String {
        let dict = self.convertToDictionary(managedObject: managedObject, ignoreAttributes: ignoreAttributes)
        var data: NSData?
        do {
            data = try JSONSerialization.data(withJSONObject: dict, options:JSONSerialization.WritingOptions(rawValue: 0)) as NSData?
        } catch {
            data = nil
        }
        
        // return result
        var s = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)!
        s = s.replacingOccurrences(of: "\"{", with: "{") as NSString
        s = s.replacingOccurrences(of: "}\"", with: "}") as NSString
        s = s.replacingOccurrences(of:"\\", with: "") as NSString
        return (s as String)
    }
    
}
