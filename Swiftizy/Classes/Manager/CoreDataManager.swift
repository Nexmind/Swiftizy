//
//  CoreDataManager.swift
//  Nexos_demo
//
//  Created by Julien Henrard on 25/11/15.
//  Copyright © 2015 NexMind. All rights reserved.
//

import Foundation
import UIKit
import CoreData


public class CoreDataManager {
    
    public static var managedContext : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    public static var Fetch: Fetching = Fetching(context: managedContext)
    public static var Create: Creating = Creating(context: managedContext)
    public static var Count: Counting = Counting(context: managedContext)
    public static var Delete: Deleting = Deleting(context: managedContext)
    
    
    /**
     Save the context after modifications
     */
    public static func save(){
        do{
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    /**
     Reset the context
     */
    public static func reset() {
        managedContext.reset()
    }
    
    /**
     Discard changes in the context since the last save
     */
    public static func discardChanges() {
        managedContext.rollback()
    }
}
