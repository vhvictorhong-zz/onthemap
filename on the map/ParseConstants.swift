//
//  ParseConstants.swift
//  On the Map
//
//  Created by Victor Hong on 2/3/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct Constants {
        
        
        static let ParseAPPID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let BaseURLSecure : String = "https://api.parse.com/1/classes/StudentLocation"
    }
    struct Methods {
       
        static let Session = "session"
        static let UsersID = "users/{id}"

        static let AccountIDFavorite = "{id}"
        
    }

    struct HTTPHeader {
        static let ParseAPPID = "X-Parse-Application-Id"
        static let ParseAPIKey = "X-Parse-REST-API-Key"
    }
    
    struct JSONResponseKeys {
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
    }

}