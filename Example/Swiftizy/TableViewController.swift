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
        self.books = CoreDataManager.Fetch.all(entity: Book.self) as? [Book]
        print("NUM OF BOOKS: \(self.books?.count)")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = books![indexPath.row].pk_title!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books![indexPath.row]
        let publisher = (book.publishers?.allObjects as! [Publisher])[0]
        let alert = UIAlertController(title: "Book details", message: "Title: \(book.pk_title!)\n Pages: \(book.number_of_pages)\n Publisher: \(publisher.name!)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
