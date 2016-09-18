//
//  StringExtension.swift
//  nexios
//
//  Created by Julien Henrard on 24/11/15.
//  Copyright © 2015 NexMind. All rights reserved.
//

import Foundation

public extension String {
    func toDouble() -> Double? {
        let formatter = NumberFormatter()
        if let number = formatter.number(from: self) {
            return number.doubleValue
        }
        if let test = Double(self) {
            return test
        }
        return nil
    }
}

public extension String {
    func toInt() -> Int? {
        let formatter = NumberFormatter()
        if let number = formatter.number(from: self) {
            return number.intValue
        }
        return nil
    }
}

public extension String {
    func containsWhiteSpace() -> Bool {
        let whitespace = NSCharacterSet.whitespaces
        let range = self.rangeOfCharacter(from: whitespace)
        if let _ = range {
            return true
        }
        else {
            return false
        }
    }
}



public extension String {
    func toFloat() -> Float? {
        let formatter = NumberFormatter()
        if let number = formatter.number(from: self) {
            return number.floatValue
        }
        return nil
    }
}

public extension String {
    func toBool() -> Bool? {
        switch self {
        case "true":
            return true
        case "false":
            return false
        default:
            return nil
        }
    }
}

public extension String
{
    var length: Int {
        get {
            return self.characters.count
        }
    }
    
    func contains(s: String) -> Bool
    {
        return (self.range(of: s) != nil) ? true : false
    }
    
    
    func isMatch(regex: String, options: NSRegularExpression.Options) -> Bool
    {
        var error: NSError?
        var exp: NSRegularExpression?
        do {
            exp = try NSRegularExpression(pattern: regex, options: options)
        } catch let error1 as NSError {
            error = error1
            exp = nil
        }
        
        if let error = error {
            print(error.description)
        }
        let matchCount = exp!.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.length))
        return matchCount > 0
    }
    
    func getMatches(regex: String, options: NSRegularExpression.Options) -> [NSTextCheckingResult]
    {
        var error: NSError?
        var exp: NSRegularExpression?
        do {
            exp = try NSRegularExpression(pattern: regex, options: options)
        } catch let error1 as NSError {
            error = error1
            exp = nil
        }
        
        if let error = error {
            print(error.description)
        }
        let matches = exp!.matches(in: self, options: [], range: NSMakeRange(0, self.length))
        return matches
    }
    
    private var vowels: [String]
        {
        get
        {
            return ["a", "e", "i", "o", "u"]
        }
    }
    
    private var consonants: [String]
        {
        get
        {
            return ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
        }
    }
    
}

extension String {
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).deletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).deletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathExtension(ext)
    }
}
