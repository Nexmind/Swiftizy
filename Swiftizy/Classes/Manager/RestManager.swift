//
//  RestManager.swift
//  nexios
//
//  Created by Julien Henrard on 24/11/15.
//  Copyright © 2015 NexMind. All rights reserved.
//

import Foundation
import UIKit

open class RestManager {
    
    /**
     GET Method on the given URL.
     - returns: Nother
     - parameter url:     The URL for calling WS.
     - parameter responseHandler:   Behavior after the request.
     */
    
    open static var authorizationString: String? = nil
    open static var authorizationNeeded: Bool = false
    
    open static func GET(_ url: String, parameters: [String: String]?, withBehavior responseHandler: @escaping (NSDictionary?, NexosError) -> Void){
        let postEndpoint: String = url
        let nError : NexosError = NexosError()
        guard let NSUrl = URL(string: postEndpoint) else {
            NSLog("---< !!! ERROR !!! >--- RestManager (GET): cannot create URL")
            return
        }
        let urlRequest = NSMutableURLRequest(url: NSUrl)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        if parameters != nil {
            for param in parameters! {
                urlRequest.addValue(param.value, forHTTPHeaderField: param.key)
            }
        }
        if authorizationNeeded {
            urlRequest.setValue("Basic \(RestManager.authorizationString!)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            guard let responseData = data else {
                NSLog("---< ! Warning ! >--- RestManager (GET): did not receive data")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = (error as! NSError).localizedFailureReason
                nError.errorCode = (error as! NSError).code
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
            do {
                let post = try JSONSerialization.jsonObject(with: responseData,
                                                            options: []) as! NSDictionary
                NSLog("|| RestManager (GET) || ---> SUCCESS")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = (error as? NSError)?.localizedFailureReason
                nError.errorCode = (error as? NSError)?.code
                responseHandler(post, nError)
            } catch  {
                NSLog("---< !!! ERROR !!! >--- RestManager (GET): trying to convert data to JSON failed")
                nError.errorTitle = "JSON Failed"
                nError.errorDescription = "Converting the response to JSON just failed"
                nError.errorCode = 207
                let post = NSMutableDictionary()
                let datastring = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)
                post.setValue(datastring, forKey: "dataString")
                responseHandler(post, nError)
                return
            }
        }
        task.resume()
    }
    
    /**
     GET Method on the given URL for array.
     - returns: Nother
     - parameter url:     The URL for calling WS.
     - parameter responseHandler:   Behavior after the request.
     */
    open static func GET(_ url: String, parameters: [String: String]?, withBehaviorForArray responseHandler: @escaping ([NSDictionary]?, NexosError) -> Void){
        let postEndpoint: String = url
        let nError : NexosError = NexosError()
        guard let NSUrl = URL(string: postEndpoint) else {
            NSLog("---< !!! ERROR !!! >--- RestManager (GET): cannot create URL")
            return
        }
        
        let urlRequest = NSMutableURLRequest(url: NSUrl, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 20)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        if parameters != nil {
            for param in parameters! {
                urlRequest.addValue(param.value, forHTTPHeaderField: param.key)
            }
        }
        if authorizationNeeded {
            urlRequest.setValue("Basic \(RestManager.authorizationString!)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest){ (data, response, error) in
            guard let responseData = data else {
                NSLog("---< ! Warning ! >--- RestManager (GET): did not receive data")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = (error as! NSError).localizedFailureReason
                nError.errorCode = (error as! NSError).code
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
                post = try JSONSerialization.jsonObject(with: responseData,
                                                        options: []) as! [NSDictionary]
                NSLog("|| RestManager (GET) || ---> SUCCESS")
                let datastring = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)
                NSLog(datastring as! String)
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = (error as! NSError).localizedFailureReason
                nError.errorCode = (error as! NSError).code
                responseHandler(post, nError)
            } catch  {
                NSLog("---< !!! ERROR !!! >--- RestManager (GET): trying to convert data to JSON failed")
                responseHandler(nil, nError)
                return
            }
        }
        task.resume()
    }
    
    
    /**
     POST Method on the given URL asynchronous
     - returns: Nother
     - parameter url:     The URL for calling WS.
     - parameter jsonToPost:   json string to send
     - parameter responseHandler:   response after the post (response, error) if not parsable, return data in string (dataString).
     */
    open static func POST(_ url: String, parameters: [String: String]?, jsonToPost: String, responseHandler: @escaping (NSDictionary?, NexosError) -> Void){
        // create the request & response
        URLCache.shared.removeAllCachedResponses()
        let request = NSMutableURLRequest(url: URL(string: url)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        // create some JSON data and configure the request
        let jsonString = jsonToPost
        request.httpBody = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if parameters != nil {
            for param in parameters! {
                request.addValue(param.value, forHTTPHeaderField: param.key)
            }
        }
        
        if authorizationNeeded {
            request.setValue("Basic \(RestManager.authorizationString!)", forHTTPHeaderField: "Authorization")
        }
        
        let nError : NexosError = NexosError()
        // send the request
        let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
            guard let responseData = data else {
                NSLog("---< ! Warning ! >--- RestManager (POST RESPONSE): did not receive data")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = (error as! NSError).localizedFailureReason
                nError.errorCode = (error as! NSError).code
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
                let datastring = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)
                NSLog(datastring as! String)
                let post = try JSONSerialization.jsonObject(with: responseData,
                                                            options: []) as! NSDictionary
                NSLog("|| RestManager (POST RESPONSE) || ---> SUCCESS")
                nError.errorTitle = error?.localizedDescription
                nError.errorDescription = (error as! NSError).localizedFailureReason
                nError.errorCode = 200
                responseHandler(post, nError)
            } catch  {
                NSLog("---< !!! ERROR !!! >--- RestManager (POST RESPONSE): trying to convert data to JSON failed")
                nError.errorTitle = "JSON Failed"
                nError.errorDescription = "Converting the response to JSON just failed"
                nError.errorCode = 207
                let datastring = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)
                post = NSMutableDictionary()
                post.setValue(datastring, forKey: "dataString")
                responseHandler(post, nError)
                return
            }
        }
        task.resume()
    }
    
    
    /**
     POST Method on the given URL synchronous
     - returns: true if success, false if failed
     - parameter url:     The URL for calling WS.
     - parameter jsonToPost:   json string to send
     */
    open static func POST_SYNCRO(_ url: String, jsonToPost: String) -> Bool{
        // create the request & response
        let request = NSMutableURLRequest(url: URL(string: url)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: URLResponse?
        
        // create some JSON data and configure the request
        let jsonString = jsonToPost
        request.httpBody = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if authorizationNeeded {
            request.setValue("Basic \(RestManager.authorizationString!)", forHTTPHeaderField: "Authorization")
        }
        
        // send the request
        do{
            try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
            // look at the response
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP response: \(httpResponse.statusCode)")
            } else {
                print("No HTTP response")
            }
            return true
        } catch {
            // look at the response
            if let httpResponse = response as? HTTPURLResponse {
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
     - parameter url: The URL for calling WS.
     - parameter jsonToSend: object in JSON you want delete
     - parameter responseHandler: the response handler when server back a response
     */
    /*open static func DELETE(_ url: String, jsonToSend: String, responseHandler: @escaping (NSDictionary?, NexosError) -> Void){
     // create the request & response
     URLCache.shared.removeAllCachedResponses()
     let request = NSMutableURLRequest(url: URL(string: url)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
     let config = URLSessionConfiguration.default
     let session = URLSession(configuration: config)
     
     
     // create some JSON data and configure the request
     let jsonString = jsonToSend
     request.httpBody = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
     request.httpMethod = "DELETE"
     request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     if authorizationNeeded {
     request.setValue("Basic \(RestManager.authorizationString!)", forHTTPHeaderField: "Authorization")
     }
     let nError : NexosError = NexosError()
     // send the request
     let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
     guard let responseData = data else {
     NSLog("---< ! Warning ! >--- RestManager (DELETE RESPONSE): did not receive data")
     nError.errorTitle = error?.localizedDescription
     nError.errorDescription = error?.localizedFailureReason
     nError.errorCode = error?.code
     responseHandler(nil, nError)
     return
     }
     guard error == nil else {
     NSLog("---< !!! ERROR !!! >--- RestManager (DELETE RESPONSE): calling GET on the given method (verify URL)")
     nError.errorTitle = nil
     nError.errorDescription = nil
     nError.errorCode = nil
     responseHandler(nil, nError)
     return
     }
     var post: NSMutableDictionary
     do {
     let datastring = NSString(data: responseData, encoding: String.Encoding.utf8)
     NSLog(datastring as! String)
     let post = try JSONSerialization.jsonObject(with: responseData,
     options: []) as! NSDictionary
     NSLog("|| RestManager (DELETE RESPONSE) || ---> SUCCESS")
     nError.errorTitle = error?.localizedDescription
     nError.errorDescription = error?.localizedFailureReason
     nError.errorCode = error?.code
     responseHandler(post, nError)
     } catch  {
     NSLog("---< !!! ERROR !!! >--- RestManager (DELETE RESPONSE): trying to convert data to JSON failed")
     nError.errorTitle = "JSON Failed"
     nError.errorDescription = "Converting the response to JSON just failed"
     nError.errorCode = 200
     let datastring = NSString(data: responseData, encoding: String.Encoding.utf8)
     post = NSMutableDictionary()
     post.setValue(datastring, forKey: "dataString")
     responseHandler(post, nError)
     return
     }
     })
     task.resume()
     }
     
     /**
     DELETE Method on the given URL without response
     - returns: Nother
     - parameter url:     The URL for calling WS.
     - parameter withBehavior:   Behavior after the request, get Bool (TRUE if SUCCESS, else FALSE).
     */
     open static func DELETE(_ url: String, withBehavior responseHandler: @escaping (Bool, NexosError) -> Void){
     let nError = NexosError()
     let firstPostEndpoint: String = url
     let firstPostUrlRequest = NSMutableURLRequest(url: URL(string: firstPostEndpoint)!)
     firstPostUrlRequest.httpMethod = "DELETE"
     
     let config = URLSessionConfiguration.default
     let session = URLSession(configuration: config)
     
     let task = session.dataTask(with: firstPostUrlRequest, completionHandler: {
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
     }*/
}
