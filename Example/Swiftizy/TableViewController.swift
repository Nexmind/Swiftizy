//
//  TableViewController.swift
//  Swiftizy
//
//  Created by Julien Henrard on 27/04/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Swiftizy

class TableViewController: UITableViewController {

    
    var books : [Book]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.books = CoreDataManager.fetchForEntity("Book") as? [Book]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books!.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let book = books![indexPath.row]
        let publisher = (book.publishers?.allObjects as! [Publisher])[0]
        let alert = UIAlertController(title: "Book details", message: "Title: \(book.pk_title!)\n Pages: \(book.number_of_pages)\n Publisher: \(publisher.name!)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = books![indexPath.row].pk_title!
        return cell
    }
}