//
//  StudentMapViewController.swift
//  On the Map
//
//  Created by Victor Hong on 2/9/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import UIKit
import MapKit

class StudentMapViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var studentMapView: MKMapView!
    @IBOutlet weak var linkShareText: UITextField!
    @IBOutlet weak var studentMapActivityView: UIActivityIndicatorView!
    
    
    var location = UdacityClient.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        linkShareText.delegate = self
        studentMapActivityView.hidesWhenStopped = true
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location.mapString!, completionHandler: { ( placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            if let placemark = placemarks?[0] {
                
                self.studentMapView.addAnnotation(MKPlacemark(placemark: placemark))
                
                let loc = CLLocationCoordinate2D(latitude: placemark.location!.coordinate.latitude, longitude: placemark.location!.coordinate.longitude)
                let region = MKCoordinateRegionMakeWithDistance(loc, 5000, 5000)
                self.studentMapView.setRegion(region, animated: true)
                
            }
        })
    
    }
    
    @IBAction func submitButton(sender: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.studentMapActivityView.startAnimating()
        })
        
        let data:[String:AnyObject] = [
            "uniqueKey": location.userID! ,
            "firstName": location.firstName!,
            "lastName" : location.lastName!,
            "mapString": location.mapString!,
            "mediaURL": self.linkShareText.text!,
            "latitude": location.latitude!,
            "longitude": location.longitude!
        ]
        print(location.userID, location.firstName, location.lastName, location.mapString)
        
        ParseClient.sharedInstance().postStudentLocation(data, completionHandler: { (result, error) in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.studentMapActivityView.stopAnimating()
                })
                self.alertAction("There is an issue creating location")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.studentMapActivityView.stopAnimating()
                })
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func alertAction(titleMessage: String) {
        let alert = UIAlertController(title: titleMessage, message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
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

}
