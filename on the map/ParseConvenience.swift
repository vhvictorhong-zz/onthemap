//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Victor Hong on 2/9/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getStudentLocations(completionHandler: (results: [StudentLocation]?, errorString: String?) -> Void) {
        var studentLocations = [StudentLocation]()
        _ = taskForGETMethod(["limit":"100", "order": "-updatedAt"], method: "") { (JSONResult, error) in
            if let error = error {
                completionHandler(results: studentLocations , errorString: error.description)
            } else {
                if let result = JSONResult.valueForKey("results") as? [[String:AnyObject]] {
                    studentLocations = StudentLocation.studentLocationsFromResults(result)
                    completionHandler(results: studentLocations , errorString: nil)
                } else {
                    completionHandler(results: studentLocations, errorString: "Failed to parse results from JSON")
                }
            }
        }
    }
    
    func postStudentLocation(data:[String:AnyObject], completionHandler: (result: String, errorString: String?) -> Void) {
        let _ = taskForPOSTMethod(Constants.BaseURLSecure, method: "", jsonBody: data) { (JSONResult , error) in
            
            if let error = error {
                completionHandler(result: "" , errorString: error.description)
            } else {
                if let result = JSONResult.valueForKey("createdAt") as? String {
                    completionHandler(result: result, errorString: nil)
                } else {
                    completionHandler(result: "", errorString: "Failed to parse object from JSON")
                }
            }
        }
    }
    
}