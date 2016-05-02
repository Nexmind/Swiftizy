# Swiftizy

[![Version](https://img.shields.io/cocoapods/v/Swiftizy.svg?style=flat)](http://cocoapods.org/pods/Swiftizy)
[![License](https://img.shields.io/cocoapods/l/Swiftizy.svg?style=flat)](http://cocoapods.org/pods/Swiftizy)
[![Platform](https://img.shields.io/cocoapods/p/Swiftizy.svg?style=flat)](http://cocoapods.org/pods/Swiftizy)

##What's Swiftizy

Swiftizy is a big help to develop Swift application using CoreData and consume REST service.

####CoreData
A lot of easy method for fetching, create, delete, predicate, and a PrimaryKey system.

####REST
Make GET, POST and DELETE easily 

####JSON
Just one line to convert your JSON in NSManagedObject subclass. No need to define key for each attributes.

####Typical type of application using Swiftizy:

1. You use CoreData and NSManagedObject subclass

2. You consume a REST service sending JSON and/or you want POST some JSON object on your server

3. You want to write the JSON object in your CoreData context with some control on these

4. You need to translate your app.


##Future features

In the next version (1.3) will add:

###Improvement of existing features

- You will be able to choose a mode in the JSON parser for each relationship of your NSManagedObject: CreateElseReturn or CreateElseUpdate

###New features

- Migration manager for CoreData


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
### Translations
First, you need to initialize your Translations system with the good language. If you allow manually language change in your app, just call again 'initialize' method with new value.
```ruby
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Translations.initialize(defaultLang: "en", currentLang: "fr")
    return true;
}
```

After, in some controller, you can easily translate yours components
```ruby
labelSignIn.text = Translations.translate("label_sign_in")
```

You just need to write the traduction file for each language you want in your app.

#### Example: en.txt (English)
labelSignIn=Sign in

buttonConnection=Connection

#### Example: fr.txt (French)
labelSignIn=Connectez-Vous

buttonConnection=Connexion


### PlistReader
The PlistReader is a simple class for read a properties list.
You need to init the PlistReader with the file you want read and execute the getField method for get your value

This work only with String field for the moment, it's used for save some information like a webservice url or something else.

#### Example: properties.plist
```ruby
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    plistReader(plistFileName: "properties")
    // Get my rest URL
    print("Your url: \(PlistReader.getField("url")!)")
    return true;
}
```

## Utilisations
### Example project
You can clone the project on your desktop and open it for get the example project.
Once open, just swap your project on "Swiftizy_example" instead "Swiftizy"
![alt tag] (http://imagizer.imageshack.us/v2/320x240q90/922/j1msIX.png)

When you launch the app, you have 5 steps. Execute it in order:

1. Get books from OpenLibrary API, with createElseReturn method: create object in CoreData if they dont, else return the object.

2. Verify everything is OK

3. Vizualize in the tableview your date: touch a row for more informations

4. Change an attribute of each book (All number_of_pages will be 10)

5. Get same book from step 1, but with createElseUpdate method: create object in CoreData, else update the object with the value in Json 

Some informations will be displayed in the logs


### CoreDataManager
When the configuration is complete and your datamodel / subclass are create, you can use the CoreDataManager: a static class who provide you a lot of method for CoreData
##### Create
```ruby
let newUser = CoreDataManager.Create.entity("User") as! User
newUser.firstname = "Jhon"
CoreDataManager.save()
```

You create with a verification if one attribute exist for dont duplicate same object. If exist, return nil
```ruby
CoreDataManager.Create.exceptIfStringMatch("User", attributeName: "firstname", attributeValue: "Jhon")
```

##### Fetch
######Simple fetching
```ruby
let users: [User] = CoreDataManager.Fetch.all("User") as! [User]
```

######Predicate
With a define predicate
```ruby
let users: [User] = CoreDataManager.Fetch.equalString("User", attributeName: "firstname", attributeValue: "Jhon") as [User]
```

With your predicate

```ruby
let users: [User] = CoreDataManager.Fetch.equalString("User", attributeName: "firstname", attributeValue: "Jhon") as [User]
```

Fetching with yours predicates (and descriptors if needed)
```ruby
let predicate: NSPredicate = NSPredicate(format: "age = %d", 27)
let predicate2: NSPredicate = NSPredicate(format: "firstname = %@", "Jhon")
let predicates: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
let users: [User] = CoreDataManager.Fetch.custom("User", descriptors: nil, predicate: predicates) as! [User]
```

######Ascending / Descending
```ruby
CoreDataManager.Fetch.orderBy("User", orderBy: "firstname", ascending: true)
```

##### Delete
Batch delete
```ruby
CoreDataManager.Delete.batch("User")
```        
Delete one
```ruby
let user = CoreDataManager.Fetch.all("User")[0] as! User
CoreDataManager.Delete.one(user)
```
Delete many
```ruby
let users = CoreDataManager.Fetch.all("User") as! [User]
CoreDataManager.Delete.many(users)
```

##### Other
```ruby
CoreDataManager.save()

CoreDataManager.reset()

CoreDataManager.discardChanges()
```


### HTTP request with JsonParser/ObjectParser
##### GET
JsonParser give you one method to consume some Json and directly create the managedObject and put information correctly in your object. 
As all Json parser, you just need the name of attributes of your entity match with the json file.
You can associate this with a GET request to get all book from a library.
Use the RestManager to perform a GET request. You have different version of the GET request, take the good version you need.
```ruby 
let url = "http://mywebservice.com/rest/book/all"
RestManager.GET(url, withBehaviorResponseForArray: {(books, error) in
    if error == nil {
        for book in books {
            // For return the object if already in CoreData (based on the primary key)
            let myBook = JsonParser.jsonToManagedObject(object, createElseReturn: Book.self)
            // For update the object with values in json if object is already in CoreData
            let myBook = JsonParser.jsonToManagedObject(object, createElseUpdate: Book.self)
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
