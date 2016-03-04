//
//  StudentLocations.swift
//  On the Map
//
//  Created by Victor Hong on 2/9/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import Foundation
import CoreLocation

struct StudentLocation {

    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Int
    var longitude: Int
    var mapString: String
    var mediaURL: String
    var objectID: String
    var uniqueKey: String
    var updatedAt: String
    
    init(dictionary: [String : AnyObject]) {
        createdAt = dictionary[ParseClient.JSONResponseKeys.createdAt] as! String
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as! Int
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as! Int
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as! String
        objectID = dictionary[ParseClient.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as! String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.updatedAt] as! String
    }
    
    static func studentLocationsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        for studentLocation in results {
            studentLocations.append(StudentLocation(dictionary: studentLocation))
        }
        
        return studentLocations
    }
    
}