//
//  JsonRelationshipDescription.swift
//  Pods
//
//  Created by Julien Henrard on 27/04/16.
//
//

import Foundation

public enum JsonRelationshipDescriptionType {
    case CreateElseReturn
    case CreateElseUpdate
}

public class JsonRelationshipDescription {
    var keys : [String]?
    var descriptions : [JsonRelationshipDescriptionType]?
    
    init(){
        keys = nil
        descriptions = nil
    }
    
    convenience init(keys: [String], descriptions: [JsonRelationshipDescriptionType]){
        self.init()
        self.keys = keys
        self.descriptions = descriptions
    }
}
