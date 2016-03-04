//
//  MapViewController.swift
//  On the Map
//
//  Created by Victor Hong on 2/9/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit
import FBSDKCoreKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        getStudentLocations()
        
    }

    @IBAction func addStudentButton(sender: AnyObject) {
        
        addStudent()
        
    }
    @IBAction func refreshButton(sender: AnyObject) {
        
        getStudentLocations()
        
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        
        logout()
        
    }
    func alertAction(titleMessage: String) {
        let alert = UIAlertController(title: titleMessage, message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getStudentLocations() {
        ParseClient.sharedInstance().getStudentLocations() { (result, error) in
            if error == nil {
                let annotations = self.makeLocations(result!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(annotations)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.alertAction("Failed to get locations")
                }
            }
        }
    }
    
    func makeLocations(locations: [StudentLocation]) -> [MKPointAnnotation] {
        
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = location.firstName
            let lastName = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
            
        }
        
        return annotations
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            (pinView! as MKPinAnnotationView).pinTintColor = MKPinAnnotationView.purplePinColor()
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        
        return pinView!
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            if let subtitle = view.annotation!.subtitle {
                if let url = NSURL(string: subtitle!) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        }
    }
    
    
    
    func logout() {
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            UdacityClient.sharedInstance().logOut() { (result, errorString) in
                if result == "success" {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.alertAction("Could not Log Out")
                }
            }
        } else {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func addStudent() {
        
        self.performSegueWithIdentifier("mapViewShowStudent", sender: self)
        
    }
    
    func removeStudent() {
        
    }

}
