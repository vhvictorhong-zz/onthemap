//
//  ParseClient.swift
//  On the Map
//
//  Created by Victor Hong on 2/3/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import Foundation

class ParseClient {
    
    var userID: String?
    var sessionID: String?
    
    let session = NSURLSession.sharedSession()
    
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
    
    func taskForGETMethod(mutableParameters: [String:String], method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.BaseURLSecure + method + ParseClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.addValue(Constants.ParseAPPID, forHTTPHeaderField: HTTPHeader.ParseAPPID)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: HTTPHeader.ParseAPIKey)
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if let error = downloadError {
                completionHandler(result: nil, error: error)
            } else {
                ParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        return task
    }
    
    func taskForPOSTMethod(base: String, method: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        let urlString = base + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.addValue(Constants.ParseAPPID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
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
                ParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
    }
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        for (key, value) in parameters {
            
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static let sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}