//
//  LoginViewController.swift
//  On the Map
//
//  Created by Victor Hong on 1/28/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    var keyboardChanged = false
    var lastKeyboardChanged: CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    var fbAccessToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameText.delegate = self
        passwordText.delegate = self
        
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email"]
        
        loginActivityIndicator.hidesWhenStopped = true
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameText.text = ""
        passwordText.text = ""
        addKeyboardDismissRecognizer()
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            let controller = storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            presentViewController(controller, animated: true, completion: nil)
            
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardDismissRecognizer()
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        
        if usernameText.text!.isEmpty {
            alertAction("Enter a username please")
        }
        
        if passwordText.text!.isEmpty {
            alertAction("Enter a password please")
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.loginActivityIndicator.startAnimating()
        })
        
        UdacityClient.sharedInstance().loginWithUsernameAndPassword(usernameText.text!, password: passwordText.text!) { (result, error) in
            if (result == "success") {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loginActivityIndicator.stopAnimating()
                })
                self.loginComplete()
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loginActivityIndicator.stopAnimating()
                })
                self.alertAction("Login Failed")
            }
        }
        
    }
    
    func alertAction(titleMessage: String) {
        let alert = UIAlertController(title: titleMessage, message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.loginActivityIndicator.startAnimating()
        })
        
        if error != nil {
            dispatch_async(dispatch_get_main_queue(), {
                self.loginActivityIndicator.stopAnimating()
            })
            alertAction("Facebook login error")
        } else if result.isCancelled {
            dispatch_async(dispatch_get_main_queue(), {
                self.loginActivityIndicator.stopAnimating()
            })
            alertAction("Facebook login cancelled")
        } else {
            if result.token == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loginActivityIndicator.stopAnimating()
                })
                alertAction("Facebook login error")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loginActivityIndicator.stopAnimating()
                })
                fbAccessToken = FBSDKAccessToken.currentAccessToken().tokenString as String
                
                UdacityClient.sharedInstance().loginWithFacebook(fbAccessToken!) { (result, error) in
                    if (result == "success") {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.loginActivityIndicator.stopAnimating()
                        })
                        self.loginComplete()
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.loginActivityIndicator.stopAnimating()
                        })
                        self.alertAction("Login Failed")
                    }
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    

    func loginComplete() {
        UdacityClient.sharedInstance().getUserInfo { ( result, error) in
            if result == "success" {
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            } else {
                self.alertAction("Login Failed")
            }
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if let url = NSURL(string: "http://www.udacity.com") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardChanged == false {
            lastKeyboardChanged = getKeyboardHeight(notification) / 2
            view.superview?.frame.origin.y -= lastKeyboardChanged
            keyboardChanged = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardChanged == true {
            view.superview?.frame.origin.y += lastKeyboardChanged
            keyboardChanged = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
}
