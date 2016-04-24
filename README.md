# Swiftizy

[![CI Status](http://img.shields.io/travis/Julien Henrard/Swiftizy.svg?style=flat)](https://travis-ci.org/Julien Henrard/Swiftizy)
[![Version](https://img.shields.io/cocoapods/v/Swiftizy.svg?style=flat)](http://cocoapods.org/pods/Swiftizy)
[![License](https://img.shields.io/cocoapods/l/Swiftizy.svg?style=flat)](http://cocoapods.org/pods/Swiftizy)
[![Platform](https://img.shields.io/cocoapods/p/Swiftizy.svg?style=flat)](http://cocoapods.org/pods/Swiftizy)

## What's Swiftizy

Swiftizy is a framework for help the development of application using CoreData, managed subclass and consume REST service with a lot of generics tools. It's only made for this kind of application:
- CoreData + managed subclass
- Consume Rest service

And others little helps :)

## Requirements

## Installation

Swiftizy is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Swiftizy"
```

##Configurations
### Import
```ruby
import Swiftizy
```
### CoreDataManager 
To use the CoreDataManager, you need first to create your own CoreData stack, declare it in AppDelegate and give your managed context to the CoreDataManager in the 
```ruby
lazy var coreDataStack = CoreDataStack()

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
  CoreDataManager.managedContext = coreDataStack.context
  return true;
}
```
### Json Parser
#####(this will be fixed soon cause it's not very cool to do this)
Swiftizy work only with managed object subclass.
For work with the parser, you need a little configuration:
#####1. In your datamodel, change the module of your entity to "None": select your entity -> datamodel inspector -> module
#####2. In your managed subclass, add the @objc annotation with the name of your Entity
```ruby
import Foundation
import CoreData

@objc(User)
class User: NSManagedObject {


// Insert code here to add functionality to your managed object subclass

}
```


### PlistReader
The PlistReader is a simple class for read a properties list.
You need to init the PlistReader with the file you want read and execute the getField method for get your value
```ruby
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
  plistReader(plistFileName: "properties")
  // Get my rest URL
  print("Your url: \(PlistReader.getField("url")!)")
}
```

## Utilisations
### CoreDataManager
When the configuration is complete and your datamodel / subclass are create, you can use the CoreDataManager: a static class who provide you a lot of method for CoreData
##### Create
```ruby
let newUser = CoreDataManager.createEntity("User") as! User
newUser.firstname = "Jhon"
newUser.lastname = "Doe"
newUser.age = 27
CoreDataManager.save()
```

##### Fetch
Simple fetching
```ruby
let users: [User] = CoreDataManager.fetchForEntity("User") as! [User]
```

Fetching with define predicate 
if the attributeValue == lastname
```ruby
let users: [User] = CoreDataManager.fetchWithPredicateWithString("User", attributeName: "lastname", attributeValue: "Doe") as [User]
```

Fetching with yours predicates
```ruby
let predicate : NSPredicate = NSPredicate(format: "age = %d", 27)
let predicate2 : NSPredicate = NSPredicate(format: "firstname = %@", "Jhon")
let users: [User] = CoreDataManager.fetchWithCustomPredicate("User", predicate: predicates) as! [User]
```

##### Delete
Batch delete
```ruby
CoreDataManager.batchDeleteEntity("User")
```        
Delete one
```ruby
CoreDataManager.deleteOneEntity(user)
```
Delete many
```ruby
CoreDataManager.deleteSomeEntity(objects: [NSManagedObject])
```

##### Other
```ruby
CoreDataManager.save()

CoreDataManager.reset()

CoreDataManager.discardChanges()
```


### HTTP request with json parser
##### GET
JsonParser give you one method to consume some Json and directly create the managedObject and put information correctly in your object. 
As all Json parser, you just need the name of attributes of your entity match with the json file.
You can associate this with a GET request to get all book from a library.
User the RestManager to perform a GET request. You have different version of the GET request, take the good version you need.
```ruby 
let url = "http://mywebservice.com/rest/book/all"
RestManager.GET(url, withBehaviorResponseForArray: {(books, error) in
  if error == nil {
    for book in books {
      let myBook = JsonParser.consumeJsonAndCreateEntityInCoreData(object, anyClass: Book.self)
    }
    CoreDataManager.save()
  }
})
```

##### POST
Object Parser can parse a managedObject in jsonString. You can combine that with a POST method.
You use the POST method, or the POST_SYNCRO, if you want synchronous request.
If the post response with some JSON, you get the response in a dictionary, like for a GET request. If response is not in json, the data is convert in string and be accessible with the key "dataString".
Swiftizy have a loot of extension for string. Here, the POST response with a BOOLEAN, so you can use the .toBool() method in the dataString.
```ruby
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
```
## Author

Julien Henrard, j.henrard@nexmind.com

## License

Swiftizy is available under the MIT license. See the LICENSE file for more info.
