//
//  Book+CoreDataProperties.swift
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

extension Book {

    @NSManaged var number_of_pages: NSNumber?
    @NSManaged var pk_title: String?
    @NSManaged var url: String?
    @NSManaged var publish_date: String?
    @NSManaged var publishers: NSSet?
    @NSManaged var cover: Cover

}
