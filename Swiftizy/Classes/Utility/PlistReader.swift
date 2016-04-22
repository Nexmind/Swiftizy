//
//  plistReader.swift
//  Nexos_demo
//
//  Created by Julien Henrard on 6/12/15.
//  Copyright © 2015 NexMind. All rights reserved.
//

import Foundation
import UIKit

class PlistReader {
    
    static var hmDict : NSDictionary?
    
    init(plistFileName : String){
        if let path = NSBundle.mainBundle().pathForResource(plistFileName, ofType: "plist")
        {
            PlistReader.hmDict = NSDictionary(contentsOfFile: path)
        }
    }
    
    class func getMainColor() -> UIColor{
        let red = Int(self.hmDict!["RED"] as! String)
        let green = Int(self.hmDict!["GREEN"] as! String)
        let blue = Int(self.hmDict!["BLUE"] as! String)
        return UIColor(red: red!, green: green!, blue: blue!)
    }
    
    class func getField(key : String) -> String?{
        if let dict = hmDict {
            return (dict[key] as? String)!
        }
        return nil
    }
    
}