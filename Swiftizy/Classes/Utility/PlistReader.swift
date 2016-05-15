//
//  plistReader.swift
//  Nexos_demo
//
//  Created by Julien Henrard on 6/12/15.
//  Copyright © 2015 NexMind. All rights reserved.
//

import Foundation
import UIKit

public class PlistReader {
    
    static var hmDict : NSDictionary?
    
    public init(plistFileName : String){
        if let path = NSBundle.mainBundle().pathForResource(plistFileName, ofType: "plist")
        {
            PlistReader.hmDict = NSDictionary(contentsOfFile: path)
        }
    }
    
    class func getField(key : String) -> String?{
        if let dict = hmDict {
            return (dict[key] as? String)!
        }
        return nil
    }
    
}