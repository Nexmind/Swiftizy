//
//  CoreDataExtension.swift
//  Nexos_demo
//
//  Created by Julien Henrard on 30/11/15.
//  Copyright © 2015 NexMind. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObject {
    func valueToStringForKey(key : String) -> String{
        var result: String
        if let _ = self.value(forKey: key) {
            result = self.value(forKey: key) as! String
        } else {
            result = ""
        }
        return result
    }
    
    func valueToIntForKey(key : String) -> Int{
        return (self.value(forKey: key) as AnyObject).integerValue ?? 0
    }
        
    func valueToDoubleForKey(key : String) -> Double{
        return self.value(forKey: key) as! Double
    }
    
    func valueToBoolForKey(key : String) -> Bool{
        return self.value(forKey: key) as! Bool
    }
}
