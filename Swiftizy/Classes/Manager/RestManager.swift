//
//  RestManager.swift
//  nexios
//
//  Created by Julien Henrard on 24/11/15.
//  Copyright © 2015 NexMind. All rights reserved.
//

import Foundation
import UIKit

public class RestManager {
    
    /**
     GET Method on the given URL.
     - returns: Nother
     - parameter url:     The URL for calling WS.
     - parameter responseHandler:   Behavior after the request.
     */
    public static func GET(url: String, withBehaviorResponse responseHandler: (NSDictionary?, NexosError) -> Void){
        let postEndpoint: String = url
        let nError : NexosError = NexosError()
        guard let NSUrl = NSURL(string: postEndpoint) else {
            NSLog("---< !!! ERROR !!! >--- RestManager (GET): cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: NSUrl)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            guard let responseData = data else {
                NSLog("---< ! Warning ! >--- RestManager (GET): did not receive data")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = error?.localizedFailureReason
                nError.errorCode = error?.code
                responseHandler(nil, nError)
                return
            }
            guard error == nil else {
                NSLog("---< !!! ERROR !!! >--- RestManager (GET): calling GET on the given method (verify URL)")
                nError.errorTitle = nil
                nError.errorDescription = nil
                nError.errorCode = nil
                return
            }
            let post: NSDictionary
            do {
                let post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
                NSLog("|| RestManager (GET) || ---> SUCCESS")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = error?.localizedFailureReason
                nError.errorCode = error?.code
                responseHandler(post, nError)
            } catch  {
                NSLog("---< !!! ERROR !!! >--- RestManager (GET): trying to convert data to JSON failed")
                responseHandler(nil, nError)
                return
            }
        })
        task.resume()
    }
    
    /**
     GET Method on the given URL.
     - returns: Nother
     - parameter url:     The URL for calling WS.
     - parameter responseHandler:   Behavior after the request.
     - parameter requestChanger: custom NSMutableURLRequest
     */
    public static func GET(url: String, changeRequestParameter requestChanger: (NSMutableURLRequest) -> Void, withBehaviorResponse responseHandler: (NSDictionary?, NexosError) -> Void){
        let postEndpoint: String = url
        let nError : NexosError = NexosError()
        guard let NSUrl = NSURL(string: postEndpoint) else {
            NSLog("---< !!! ERROR !!! >--- RestManager (GET): cannot create URL")
            return
        }
        let urlRequest = NSMutableURLRequest(URL: NSUrl)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        requestChanger(urlRequest)
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            guard let responseData = data else {
                NSLog("---< ! Warning ! >--- RestManager (GET): did not receive data")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = error?.localizedFailureReason
                nError.errorCode = error?.code
                responseHandler(nil, nError)
                return
            }
            guard error == nil else {
                NSLog("---< !!! ERROR !!! >--- RestManager (GET): calling GET on the given method (verify URL)")
                nError.errorTitle = nil
                nError.errorDescription = nil
                nError.errorCode = nil
                return
            }
            let post: NSDictionary
            do {
                let post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
                NSLog("|| RestManager (GET) || ---> SUCCESS")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = error?.localizedFailureReason
                nError.errorCode = error?.code
                responseHandler(post, nError)
            } catch  {
                NSLog("---< !!! ERROR !!! >--- RestManager (GET): trying to convert data to JSON failed")
                responseHandler(nil, nError)
                return
            }
        })
        task.resume()
    }
    
    /**
     GET Method on the given URL for array.
     - returns: Nother
     - parameter url:     The URL for calling WS.
     - parameter responseHandler:   Behavior after the request.
     */
    public static func GET(url: String, withBehaviorResponseForArray responseHandler: ([NSDictionary]?, NexosError) -> Void){
        let postEndpoint: String = url
        let nError : NexosError = NexosError()
        guard let NSUrl = NSURL(string: postEndpoint) else {
            NSLog("---< !!! ERROR !!! >--- RestManager (GET): cannot create URL")
            return
        }
        
        let urlRequest = NSURLRequest(URL: NSUrl, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 20)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            guard let responseData = data else {
                NSLog("---< ! Warning ! >--- RestManager (GET): did not receive data")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = error?.localizedFailureReason
                nError.errorCode = error?.code
                return
            }
            guard error == nil else {
                NSLog("---< !!! ERROR !!! >--- RestManager (GET): calling GET on the given method (verify URL)")
                nError.errorTitle = nil
                nError.errorDescription = nil
                nError.errorCode = nil
                return
            }
            let post: [NSDictionary]
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! [NSDictionary]
                NSLog("|| RestManager (GET) || ---> SUCCESS")
                var datastring = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                NSLog(datastring as! String)
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = error?.localizedFailureReason
                nError.errorCode = error?.code
                responseHandler(post, nError)
            } catch  {
                NSLog("---< !!! ERROR !!! >--- RestManager (GET): trying to convert data to JSON failed")
                responseHandler(nil, nError)
                return
            }
        })
        task.resume()
    }
    
    /**
     GET Method on the given URL for array.
     - returns: Nother
     - parameter url:     The URL for calling WS.
     - parameter responseHandler:   Behavior after the request.
     - parameter requestChanger: custom NSMutableURLRequest
     */
    public static func GET(url: String, changeRequestParameter requestChanger: (NSMutableURLRequest) -> Void,withBehaviorResponseForArray responseHandler: ([NSDictionary]?, NexosError) -> Void){
        let postEndpoint: String = url
        let nError : NexosError = NexosError()
        guard let NSUrl = NSURL(string: postEndpoint) else {
            NSLog("---< !!! ERROR !!! >--- RestManager (GET): cannot create URL")
            return
        }
        
        let urlRequest = NSMutableURLRequest(URL: NSUrl, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 20)
        requestChanger(urlRequest)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            guard let responseData = data else {
                NSLog("---< ! Warning ! >--- RestManager (GET): did not receive data")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = error?.localizedFailureReason
                nError.errorCode = error?.code
                return
            }
            guard error == nil else {
                NSLog("---< !!! ERROR !!! >--- RestManager (GET): calling GET on the given method (verify URL)")
                nError.errorTitle = nil
                nError.errorDescription = nil
                nError.errorCode = nil
                return
            }
            let post: [NSDictionary]
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! [NSDictionary]
                NSLog("|| RestManager (GET) || ---> SUCCESS")
                var datastring = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                NSLog(datastring as! String)
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = error?.localizedFailureReason
                nError.errorCode = error?.code
                responseHandler(post, nError)
            } catch  {
                NSLog("---< !!! ERROR !!! >--- RestManager (GET): trying to convert data to JSON failed")
                responseHandler(nil, nError)
                return
            }
        })
        task.resume()
    }
    
    
    /**
     POST Method on the given URL asynchronous
     - returns: Nother
     - parameter url:     The URL for calling WS.
     - parameter jsonToPost:   json string to send
     - parameter responseHandler:   response after the post (response, error) if not parsable, return data in string (dataString).
     */
    public static func POST(url: String, jsonToPost: String, responseHandler: (NSDictionary?, NexosError) -> Void){
        // create the request & response
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        let request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        
        // create some JSON data and configure the request
        let jsonString = jsonToPost
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let nError : NexosError = NexosError()
        // send the request
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            guard let responseData = data else {
                NSLog("---< ! Warning ! >--- RestManager (POST RESPONSE): did not receive data")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = error?.localizedFailureReason
                nError.errorCode = error?.code
                responseHandler(nil, nError)
                return
            }
            guard error == nil else {
                NSLog("---< !!! ERROR !!! >--- RestManager (POST RESPONSE): calling GET on the given method (verify URL)")
                nError.errorTitle = nil
                nError.errorDescription = nil
                nError.errorCode = nil
                responseHandler(nil, nError)
                return
            }
            var post: NSMutableDictionary
            do {
                let datastring = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                NSLog(datastring as! String)
                let post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
                NSLog("|| RestManager (POST RESPONSE) || ---> SUCCESS")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = error?.localizedFailureReason
                nError.errorCode = error?.code
                responseHandler(post, nError)
            } catch  {
                NSLog("---< !!! ERROR !!! >--- RestManager (POST RESPONSE): trying to convert data to JSON failed")
                nError.errorTitle = "JSON Failed"
                nError.errorDescription = "Converting the response to JSON just failed"
                nError.errorCode = 200
                let datastring = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                post = NSMutableDictionary()
                post.setValue(datastring, forKey: "dataString")
                responseHandler(post, nError)
                return
            }
        })
        task.resume()
    }
    
    /**
     POST Method on the given URL synchronous
     - returns: true if success, false if failed
     - parameter url:     The URL for calling WS.
     - parameter jsonToPost:   json string to send
     */
    public static func POST_SYNCRO(url: String, jsonToPost: String) -> Bool{
        // create the request & response
        let request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        
        // create some JSON data and configure the request
        let jsonString = jsonToPost
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send the request
        do{
            try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            // look at the response
            if let httpResponse = response as? NSHTTPURLResponse {
                print("HTTP response: \(httpResponse.statusCode)")
            } else {
                print("No HTTP response")
            }
            return true
        } catch {
            // look at the response
            if let httpResponse = response as? NSHTTPURLResponse {
                print("HTTP response: \(httpResponse.statusCode)")
            } else {
                print("No HTTP response")
            }
            return false
        }
        
    }
    
    /**
     DELETE Method on the given URL without response
     - returns: Nother
     - parameter url:     The URL for calling WS.
     */
    static func DELETE(url: String){
        let firstPostEndpoint: String = url
        let firstPostUrlRequest = NSMutableURLRequest(URL: NSURL(string: firstPostEndpoint)!)
        firstPostUrlRequest.HTTPMethod = "DELETE"
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(firstPostUrlRequest)
        NSLog("|| RestManager (DELETE) || ---> SUCCESS")
        task.resume()
    }
    
    /**
     DELETE Method on the given URL without response
     - returns: Nother
     - parameter url:     The URL for calling WS.
     - parameter withBehavior:   Behavior after the request, get Bool (TRUE if SUCCESS, else FALSE).
     */
    static func DELETE(url: String, withBehavior responseHandler: (Bool, NexosError) -> Void){
        let nError = NexosError()
        let firstPostEndpoint: String = url
        let firstPostUrlRequest = NSMutableURLRequest(URL: NSURL(string: firstPostEndpoint)!)
        firstPostUrlRequest.HTTPMethod = "DELETE"
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(firstPostUrlRequest, completionHandler: {
            (data, response, error) in
            var success = true
            guard let _ = data else {
                success = false
                NSLog("---< !!! ERROR !!! >--- RestManager (DELETE): calling DELETE on given method")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = error?.localizedFailureReason
                nError.errorCode = error?.code
                return
            }
            NSLog("|| RestManager (DELETE) || ---> SUCCESS")
            responseHandler(success, nError)
        })
        task.resume()
    }
}