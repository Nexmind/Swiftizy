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
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium;
        formatter.timeStyle = .none;
        return formatter.string(from: self as Date) as NSString?
    }
    
    func dateTimeToString() -> NSString? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: self as Date) as NSString?
    }
    
    func dateToStringHyphen() -> NSString? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: self as Date) as NSString?
    }
    
    func dateTimeFrString() -> NSString? {
        let formatter = DateFormatter()
        formatter.dateFormat = "Le dd du MM yyyy à HH:mm"
        return formatter.string(from: self as Date) as NSString?
    }
    
    func toString() -> NSString? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self as Date) as NSString?
    }
}
