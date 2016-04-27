//
//  Cover+CoreDataProperties.swift
//  
//
//  Created by Julien Henrard on 27/04/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Cover {

    @NSManaged var small: String?
    @NSManaged var large: String?
    @NSManaged var medium: String?

}
