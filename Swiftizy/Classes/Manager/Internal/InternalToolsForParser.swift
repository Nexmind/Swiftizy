//
//  ParserForNexORM.swift
//  SandwichsViewer
//
//  Created by Julien Henrard on 16/01/16.
//  Copyright © 2016 NexMind. All rights reserved.
//

import Foundation

public class InternalToolsForParser {
    
    static func attributeIsPK(name: String) -> Bool {
        if name.contains("pk") {
            return true
        } else {
            return false
        }
    }
    
    static func getPkAttributeName(name: String) -> String {
        var index = name.index(name.startIndex, offsetBy: 3)
        return name.substring(from: index)
        //return name.subStr(startIndex: 3, length: (name.length - 3))
    }
    
    static func propertyIsNil(name: String, dic: NSDictionary) -> Bool {
        if let _ = dic[name] as? NSNull {
            return true
        } else {
            return false
        }
    }
}
