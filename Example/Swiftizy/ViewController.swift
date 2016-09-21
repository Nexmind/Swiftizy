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
    
    
    // Slow Reading
    let urlBook1 = "https://openlibrary.org/api/books?bibkeys=ISBN:9780980200447&jscmd=data&format=json"
    
    // Harry Potter
    let urlBook2 = "https://openlibrary.org/api/books?bibkeys=ISBN:9780545010221&jscmd=data&format=json"
    
    // Tom Sawyer
    let urlBook3 = "https://openlibrary.org/api/books?bibkeys=ISBN:0486400778&jscmd=data&format=json"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadBooksInCoreData(sender: AnyObject) {
        
        // Just for the example, the title is tagged as the primary key. Like that, you can press the button a lot of time, books will not duplicate
        
        // We need this line: (response!.allValues[0] as! NSDictionary) because JSON on OpenLib have not a good format for our model, so the real json object we need is the first value of the JSON file that openlibrary return
        
        self.progressBarDisplayer(msg: "Loading books...", true)
        RestManager.GET(urlBook1, parameters: nil, withBehavior: {(response, error) in
            DispatchQueue.main.async {
                let book = JsonParser.jsonToManagedObject(dic: (response!.allValues[0] as! NSDictionary), createElseReturn: Book.self, ignoreAttributes: ["number_of_pages"]) as! Book
                
                print("\n-----< Book 1 >----- Hi, i'm \(book.pk_title!), and my number of pages is \(book.number_of_pages) cause i ignore this attribute")
                CoreDataManager.save()
                let book2 = JsonParser.jsonToManagedObject(dic: (response!.allValues[0] as! NSDictionary), createElseReturn: Book.self, ignoreAttributes: nil) as! Book
                print(ObjectParser.convertToJsonString(managedObject: book2, ignoreAttributes: ["name", "publishers", "cover"]))
            }
        })
        
        RestManager.GET(urlBook2, parameters: nil, withBehavior: {(response, error) in
            DispatchQueue.main.async {
                let book2 = JsonParser.jsonToManagedObject(dic: (response!.allValues[0] as! NSDictionary), createElseReturn: Book.self, ignoreAttributes: nil) as! Book
                CoreDataManager.save()
                print("\n-----< Book 2 >----- Hi, i'm \(book2.pk_title!), and my number of pages is \(book2.number_of_pages!)... Oops, my URL seems to dont return number_of_pages attributes ;-)")
            }
        })
        
        RestManager.GET(urlBook3, parameters: nil, withBehavior: {(response, error) in
            DispatchQueue.main.async {
                let book3 = JsonParser.jsonToManagedObject(dic: (response!.allValues[0] as! NSDictionary), createElseReturn: Book.self, ignoreAttributes: nil) as! Book
                CoreDataManager.save()
                print("\n-----< Book 3 >----- Hi, i'm \(book3.pk_title!), and my number of pages is \(book3.number_of_pages!) ")
                self.progressBarCanceler()
            }
        })
    }
    
    @IBAction func deleteBooks(sender: AnyObject) {
        if #available(iOS 9.0, *) {
            CoreDataManager.Delete.batch(entity: Book.self)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    
    @IBAction func verifyIfBooksAreInCoreData(sender: AnyObject) {
        let books = CoreDataManager.Fetch.all(entity: Book.self) as! [Book]
        print("count of books: \(books.count)")
        let count = CoreDataManager.Count.all(entity: Book.self)
        let alert = UIAlertController(title: "Hey dude ! ", message: "I'm CoreData ! And i have \(count) books in my context ! ;-)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func modifyBooksValue(sender: AnyObject) {
    
        let books = CoreDataManager.Fetch.all(entity: Book.self) as! [Book]
        
        for book in books {
            book.number_of_pages = 10
        }
        
        CoreDataManager.save()
        let alert = UIAlertController(title: "Hey", message: "It's again me, CoreData ! Fort this test, i will put all the number_of_pages value for each book to value 10 ! Check in the tableview if all is OK after :)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func getBookCreateElseUpdate(sender: AnyObject) {
        let alert = UIAlertController(title: "Rest", message: "I will reload all data from the rest service, if they already exist, i update them with the value in the json... Check in tableview after if its update", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        RestManager.authorizationNeeded = false
        
        self.present(alert, animated: true, completion: {() in
        
            self.progressBarDisplayer(msg: "Loading books...", true)
            RestManager.GET(self.urlBook1, parameters: nil, withBehavior: {(response, error) in
                DispatchQueue.main.async {
                    JsonParser.jsonToManagedObject(dic: (response!.allValues[0] as! NSDictionary), createElseUpdate: Book.self, ignoreAttributes: ["number_of_pages"]) as! Book
                    print("\n-----< Book 1 >----- I'm fresh ! Just get update from rest service")
                    CoreDataManager.save()
                }
            })
            
            RestManager.GET(self.urlBook2, parameters: nil, withBehavior: {(response, error) in
                DispatchQueue.main.async {
                    JsonParser.jsonToManagedObject(dic: (response!.allValues[0] as! NSDictionary), createElseUpdate: Book.self, ignoreAttributes: nil) as! Book
                    CoreDataManager.save()
                    print("\n-----< Book 2 >----- I'm fresh ! Just get update from rest service")
                }
            })
            
            RestManager.GET(self.urlBook3, parameters: nil, withBehavior: {(response, error) in
                DispatchQueue.main.async{
                    JsonParser.jsonToManagedObject(dic: (response!.allValues[0] as! NSDictionary), createElseUpdate: Book.self, ignoreAttributes: nil) as! Book
                    CoreDataManager.save()
                    print("\n-----< Book 3 >----- I'm fresh ! Just get update from rest service")
                    self.progressBarCanceler()
                }
            })

            
        })
        
        
    }
    
    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        self.view.isUserInteractionEnabled = false
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.white
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
        self.view.isUserInteractionEnabled = true
        messageFrame.removeFromSuperview()
    }
}

