//
//  ViewController.swift
//  Swiftizy
//
//  Created by Julien Henrard on 04/23/2016.
//  Copyright (c) 2016 Julien Henrard. All rights reserved.
//

import UIKit
import Swiftizy

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let newUser = CoreDataManager.createEntity("User") as! User
        newUser.firstname = "Jhon"
        newUser.lastname = "Doe"
        newUser.age = "27"
        CoreDataManager.save()
        
        let users: [User] = CoreDataManager.fetchForEntity("User") as! [User]
        
        let predicate : NSPredicate = NSPredicate(format: "age = %d", 27)
        let predicate2 : NSPredicate = NSPredicate(format: "firstname = %@", "Jhon")
        let users: [User] = CoreDataManager.fetchWithCustomPredicate("User", predicate: predicates) as! [User]
        
        let users: [User] = CoreDataManager.fetchWithPredicateWithString("User", attributeName: "lastname", attributeValue: "Doe") as [User]
        
        let url = /*URL FOR GET A LIST OF OBJECT IN JSON*/
        RestManager.GET(url, withBehaviorResponseForArray: {(response, error) in
            if error == nil {
                for object in response {
                    let entity = JsonParser.consumeJsonAndCreateEntityInCoreData(object, anyClass: Entity.self)
                }
                CoreDataManager.save()
            }
        })
        
        RestManager.
        
        let url= "http://mywebservice.com/rest/book/post"
        let aBook = CoreDataManager.fetchWithPredicateWithString("Book", attributeName: "title", attributeValue: "Harry Potter")[0] as! User
        let jsonBook = ObjectParser.convertToJsonString(aBook)
        RestManager.POST(url, jsonToPost: jsonBook, responseHandler: {(response, error) in
            if error == nil {
                if (response["dataString"] as! String).toBool() {
                    print("Success")
                } else {
                    print("Post Failed, server return false)")
                }
            }
        })
        // Batch delete
        CoreDataManager.batchDeleteEntity("User")
        
        // Delete one
        CoreDataManager.deleteOneEntity("User")
        
        // Delete many
        CoreDataManager.deleteSomeEntity(<#T##objects: [NSManagedObject]##[NSManagedObject]#>)
        
        // Count
        CoreDataManager.countEntity("User")
        
        // Save
        CoreDataManager.save()
        
        // Reset
        CoreDataManager.reset()
        
        // Discard changes
        CoreDataManager.discardChanges()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

