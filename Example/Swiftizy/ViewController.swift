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
    
    
    var messageFrame = UIView()
    var activityIndicatorView: UIActivityIndicatorView? = nil
    var strLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadBooksInCoreData(sender: AnyObject) {
        // Slow Reading
        let urlBook1 = "https://openlibrary.org/api/books?bibkeys=ISBN:9780980200447&jscmd=data&format=json"
        
        // Harry Potter
        let urlBook2 = "https://openlibrary.org/api/books?bibkeys=ISBN:9780545010221&jscmd=data&format=json"
        
        // Tom Sawyer
        let urlBook3 = "https://openlibrary.org/api/books?bibkeys=ISBN:0486400778&jscmd=data&format=json"
        
        
        
        // Just for the example, the title is tagged as the primary key. Like that, you can press the button a lot of time, books will not duplicate
        
        // We need this line: (response!.allValues[0] as! NSDictionary) because JSON on OpenLib have not a good format for our model, so the real json object we need is the first value of the JSON file that openlibrary return
        
        RestManager.GET(urlBook1, withBehaviorResponse: {(response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                JsonParser.consumeJsonAndCreateEntityInCoreData((response!.allValues[0] as! NSDictionary), anyClass: Book.self)
                CoreDataManager.save()
                print("Book 1 saved !")
            }
        })
        
        // We well modify the next book
        self.progressBarDisplayer("Loading books...", true)
        RestManager.GET(urlBook2, withBehaviorResponse: {(response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                let book2 = JsonParser.consumeJsonAndCreateEntityInCoreData((response!.allValues[0] as! NSDictionary), anyClass: Book.self) as! Book
                book2.number_of_pages = 500
                CoreDataManager.save()
                print("Book 2 modified and saved !")
            }
        })
        
        RestManager.GET(urlBook3, withBehaviorResponse: {(response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                JsonParser.consumeJsonAndCreateEntityInCoreData((response!.allValues[0] as! NSDictionary), anyClass: Book.self) as! Book
                CoreDataManager.save()
                print("Book 3 saved !")
                self.progressBarCanceler()
            }
        })
        
        /*
         Imagine, you can do it if you get on list of object
         Example:
         RestManager.GET(urlWithManyBooks, withBehaviorResponseForArray: {(responses, error) in
         if error == nil {
         for response in responses {
         JsonParser.consumeJsonAndCreateEntityInCoreData(response, anyClass: Book.self)
         }
         }
         })
         */
    }
    
    @IBAction func deleteBooks(sender: AnyObject) {
        if #available(iOS 9.0, *) {
            CoreDataManager.batchDeleteEntity("Book")
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    
    @IBAction func verifyIfBooksAreInCoreData(sender: AnyObject) {
        let books = CoreDataManager.fetchForEntity("Book") as! [Book]
        print("count of books: \(books.count)")
        var index = 0
        for book in books {
            index += 1
            print("\nBook \(index): \(book.pk_title!). Number of pages: \(book.number_of_pages!)")
            if book.publishers!.count > 0 {
                for publisher in book.publishers! {
                    print("Publisher: \(publisher.name!)")
                }
            }
        }
        let alert = UIAlertController(title: "Yep...", message: "You should look your logs ;-)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        self.view.userInteractionEnabled = false
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicatorView.startAnimating()
            messageFrame.addSubview(activityIndicatorView)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    func progressBarCanceler(){
        self.view.userInteractionEnabled = true
        messageFrame.removeFromSuperview()
    }
}

