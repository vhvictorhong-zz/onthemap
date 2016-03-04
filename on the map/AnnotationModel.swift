//
//  AnnotationModel.swift
//  On the Map
//
//  Created by Victor Hong on 3/4/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import Foundation
import MapKit

class AnnotationModel: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
