//
//  StudentViewController.swift
//  On the Map
//
//  Created by Victor Hong on 2/9/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import UIKit
import MapKit

class StudentViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var studentActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationText: UITextField!
    
    var student = UdacityClient.sharedInstance()
    
    override func viewDidLoad() {
        
        studentActivityIndicator.hidesWhenStopped = true
        navigationController?.navigationBar.hidden = false
        
    }
    
    @IBAction func findMapButton(sender: AnyObject) {
        
        if locationText.text!.isEmpty {
            alertAction("Enter a location please")
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.studentActivityIndicator.startAnimating()
        }
        
        student.mapString = locationText.text
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(student.mapString!, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            if let placemark = placemarks?[0] {
                
                
                self.student.latitude = placemark.location?.coordinate.latitude
                self.student.longitude = placemark.location?.coordinate.longitude
                self.performSegueWithIdentifier("showMapViewController", sender: self)
                dispatch_async(dispatch_get_main_queue()) {
                    self.studentActivityIndicator.stopAnimating()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.alertAction("Could not find location")
                    self.studentActivityIndicator.stopAnimating()
                }
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

}
