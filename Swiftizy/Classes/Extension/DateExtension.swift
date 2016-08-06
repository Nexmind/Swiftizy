//
//  DateExtension.swift
//  Crunchizy
//
//  Created by Julien Henrard on 14/12/15.
//  Copyright © 2015 NexMind. All rights reserved.
//

import Foundation

public extension NSDate {
    
    // -> Date System Formatted Medium
    func ToDateMediumString() -> NSString? {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle;
        formatter.timeStyle = .NoStyle;
        return formatter.stringFromDate(self)
    }
    
    func dateTimeToString() -> NSString? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.stringFromDate(self)
    }
    
    func dateToStringHyphen() -> NSString? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.stringFromDate(self)
    }
    
    func dateTimeFrString() -> NSString? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "Le dd du MM yyyy à HH:mm"
        return formatter.stringFromDate(self)
    }
    
    func toString() -> NSString? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.stringFromDate(self)
    }
}