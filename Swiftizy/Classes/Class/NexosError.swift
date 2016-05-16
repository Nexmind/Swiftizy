//
//  NexosError.swift
//  Nexos
//
//  Created by Julien Henrard on 25/11/15.
//  Copyright © 2015 NexMind. All rights reserved.
//

import Foundation

public class NexosError{
    public var errorTitle : String?
    public var errorDescription : String?
    public var errorCode : Int?
    
    init(){
        errorTitle = nil
        errorDescription = nil
        errorCode = nil
    }
    
    init(_errorTitle : String, _errorDescription : String, _errorCode : Int){
        self.errorTitle = _errorTitle
        self.errorDescription = _errorDescription
        self.errorCode = _errorCode
    }
    
    public func print(){
        if (errorCode != nil && errorDescription != nil){
            NSLog("---< !!! ERROR !!! >--- (%@): %@", (errorCode?.description)!, errorDescription!)
        }
    }
}