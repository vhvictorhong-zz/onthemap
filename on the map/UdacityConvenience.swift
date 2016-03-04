//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Victor Hong on 2/3/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func loginWithUsernameAndPassword(username: String, password: String, completionHandler: (result: String, errorString: String?) -> Void) {
        let data:[String:AnyObject] = [
            "udacity": [
                "username" : username,
                "password" : password
            ]
        ]
        
        let _ = taskForPOSTMethod(Constants.AuthorizationURL, method: Methods.Session,jsonBody: data) { (JSONResult , error) in
            if let error = error {
                completionHandler(result: "" , errorString: error.description)
            } else {
                if let result = JSONResult.valueForKey("session") as? [String:String] {
                    if let session = result["id"] {
                        self.sessionID = session
                    }
                } else {
                    completionHandler(result: "", errorString: "Failed to parse session from JSON")
                }
                if let account = JSONResult.valueForKey("account") as? NSDictionary {
                    if let userID = account["key"] as? String {
                        self.userID = userID
                        completionHandler(result: "success", errorString: nil)
                    }
                } else {
                    completionHandler(result: "", errorString: "Failed to parse userID from JSON")
                }
            }
        }
    }
    
    func loginWithFacebook(facebookAccessToken: String, completionHandler: (result: String, errorString: String?) -> Void) {
        
        let _ = taskForPostFacebookMethod(Constants.AuthorizationURL, method: Methods.Session, token: facebookAccessToken) {
            (JSONResult, error) in
            if let error = error {
                completionHandler(result: "", errorString: error.description)
            } else {
                if let result = JSONResult.valueForKey("session") as? [String: String] {
                    if let session = result["id"] {
                        self.sessionID = session
                    }
                } else {
                    completionHandler(result: "", errorString: "Failed to parse session from JSON")
                }
                if let account = JSONResult.valueForKey("account") as? NSDictionary {
                    if let userID = account["key"] as? String {
                        self.userID = userID
                        completionHandler(result: "success", errorString: nil)
                    }
                } else {
                    completionHandler(result: "", errorString: "Failed to parse userID from JSON")
                }
            }
        }
    }
    
    func logOut(completionHandler: (result: String, errorString: String?) -> Void) {
        
        let _ = taskForDELETEMethod(Constants.AuthorizationURL, method: Methods.Session) {
            (JSONResult, error) in
            if let error = error {
                completionHandler(result: "", errorString: error.description)
            } else {
                completionHandler(result: "success", errorString: nil)
            }
        }
    }
    
    func getUserInfo(completionHandler: (results: String, errorString: String? ) -> Void) {
        
        let _ = taskForGETMethod(Methods.UsersID + "/\(userID!)", completionHandler: {(result, error) in
            if let result = result.valueForKey("user") as? [String:AnyObject] {
                if let lastname = result["last_name"] as? String {
                    self.lastName = lastname
                    if let firstname = result["first_name"] as? String {
                        self.firstName = firstname
                        completionHandler(results: "success", errorString: nil)
                    } else {
                        completionHandler(results: "" , errorString: "Failed to parse firstname from JSON")
                    }
                } else {
                    completionHandler(results: "" , errorString: "Failed to parse lastname from JSON")
                }
            } else {
                completionHandler(results: "" , errorString: "Failed to parse user from JSON")
            }
        })
    }
    
}