//
//  UdacityClient.swift
//  On the Map
//
//  Created by Victor Hong on 2/1/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    var session: NSURLSession
    var sessionID: String?
    var userID: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            
            static var sharedInstance = UdacityClient()
            
        }
        
        return Singleton.sharedInstance
        
    }
    
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.AuthorizationURL + method
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            UdacityClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
        
    }
    
    func taskForPOSTMethod(base: String, method: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = base + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
        } catch {
            request.HTTPBody = nil
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if downloadError != nil {
                completionHandler(result: nil, error: downloadError)
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                ParseClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        return task
    }
    
    func taskForPostFacebookMethod(base: String, method: String, token: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = base + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(token)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if downloadError != nil {
                completionHandler(result: nil, error: downloadError)
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                ParseClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
        
    }
    
    func taskForDELETEMethod(base: String, method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = base + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-Token")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            
            if downloadError != nil {
                completionHandler(result: nil, error: downloadError)
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                ParseClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
        
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsingError: NSError? = nil
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
}