//
//  ListViewController.swift
//  On the Map
//
//  Created by Victor Hong on 2/9/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var studentLocations: [StudentLocation] = [StudentLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStudentLocations()
        
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        
        logout()
        
    }
    
    @IBAction func addStudent(sender: AnyObject) {
        
        addStudentLocation()
        
    }
    
    @IBAction func refreshStudent(sender: AnyObject) {
        
        getStudentLocations()
        
    }
    
    func alertAction(titleMessage: String) {
        let alert = UIAlertController(title: titleMessage, message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getStudentLocations() {
        
        ParseClient.sharedInstance().getStudentLocations() { (result, error) in
            
            if let results = result {
                self.studentLocations = results
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.alertAction("Failed to get locations")
                }
            }
            
        }
        
    }
    
    func addStudentLocation() {
        
        self.performSegueWithIdentifier("tableShowStuden", sender: self)
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentLocations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("mapCell")!
        let studentLocation = studentLocations[indexPath.row]
        
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel?.text = studentLocation.mediaURL
        cell.imageView?.image = UIImage(named: "BluePin")

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let url = NSURL(string: studentLocations[indexPath.row].mediaURL) {
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    func logout() {
        
        if  (FBSDKAccessToken.currentAccessToken() == nil) {
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


}
