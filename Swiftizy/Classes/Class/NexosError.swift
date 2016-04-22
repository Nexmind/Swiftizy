//
//  NexosError.swift
//  Nexos
//
//  Created by Julien Henrard on 25/11/15.
//  Copyright © 2015 NexMind. All rights reserved.
//

import Foundation

public class NexosError{
    var errorTitle : String?
    var errorDescription : String?
    var errorCode : Int?
    
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