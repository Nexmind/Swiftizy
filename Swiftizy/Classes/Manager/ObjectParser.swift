//
//  ManagedParser.swift
//  Crunchizy
//
//  Created by Julien Henrard on 17/01/16.
//  Copyright © 2016 NexMind. All rights reserved.
//

import UIKit
import CoreData

public class ObjectParser: NSObject {
    
    
    public class func convertToArray(managedObjects:NSArray?, parentNode:String? = nil) -> NSArray {
        
        let rtnArr:NSMutableArray = NSMutableArray();
        //--
        if let managedObjs:[NSManagedObject] = managedObjects as? [NSManagedObject] {
            for managedObject:NSManagedObject in managedObjs {
                rtnArr.addObject(self.convertToDictionary(managedObject, parentNode: parentNode));
            }
        }
        
        return rtnArr;
    } //F.E.
    
    public class func convertToDictionary(managedObject:NSManagedObject, parentNode:String? = nil) -> NSDictionary {
        
        let rtnDict:NSMutableDictionary = NSMutableDictionary();
        //-
        let entity:NSEntityDescription = managedObject.entity;
        let properties:[String] = (entity.propertiesByName as NSDictionary).allKeys as! [String];
        //--
        let parentNode:String = parentNode ?? managedObject.entity.name!;
        for property:String in properties  {
            var currentProperty = property
            if InternalToolsForParser.attributeIsPK(property) {
                currentProperty = InternalToolsForParser.getPkAttributeName(property)
            }
            if (currentProperty.caseInsensitiveCompare(parentNode) != NSComparisonResult.OrderedSame)
            {
                let value: AnyObject? = managedObject.valueForKey(property);
                //--
                if let set:NSSet = value as? NSSet  {
                    rtnDict[currentProperty] = self.convertToArray(set.allObjects, parentNode: parentNode);
                } else if let vManagedObject:NSManagedObject = value as? NSManagedObject {
                    
                    if (vManagedObject.entity.name != parentNode) {
                        rtnDict[currentProperty] = self.convertToDictionary(vManagedObject, parentNode: parentNode);
                    }
                } else  if let vData:AnyObject = value {
                    rtnDict[currentProperty] = vData;
                }
            }
        }
        
        return rtnDict;
    } //F.E.
    
    public class func convertToJsonString(managedObject:NSManagedObject) -> String {
        let dict = self.convertToDictionary(managedObject)
        var data: NSData?
        do {
            data = try NSJSONSerialization.dataWithJSONObject(dict, options:NSJSONWritingOptions(rawValue: 0))
        } catch {
            data = nil
        }
        
        // return result
        var s = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        s = s.stringByReplacingOccurrencesOfString("\"{", withString: "{", options: NSStringCompareOptions.LiteralSearch, range: nil)
        s = s.stringByReplacingOccurrencesOfString("}\"", withString: "}", options: NSStringCompareOptions.LiteralSearch, range: nil)
        s = s.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return (s as String)
    }
    
}