//
//  LoginViewController.swift
//  OoOsers
//
//  Created by Wei Wu on 8/30/15.
//  Copyright (c) 2015 ooosers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextfield: UITextField!
    @IBOutlet weak var userPasswordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextfield.text
        let userPassword = userPasswordTextfield.text
        
        // Fetch the data locally. For testing purpose!
//        let userEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
//        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
//        
//        if (userEmail == userEmailStored) {
//            if (userPassword == userPasswordStored) {
//                // Login is successful
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
//                NSUserDefaults.standardUserDefaults().synchronize()
//                self.dismissViewControllerAnimated(true, completion: nil)
//            } else {
//                displayMyAlertMessage("Email or Password is not correct!")
//            }
//        } else {
//            displayMyAlertMessage("Email or Password is not correct!")
//        }
        
        
        
        if (userEmail.isEmpty || userPassword.isEmpty) {
            displayMyAlertMessage("Please Enter Email and Password!")
            return
        
        }
        
        // Send user data to server side
        let myUrl = NSURL(string: "http://www.ooosers.com/ooosers/tests/iOSusages/userLogin.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "email=\(userEmail)&password=\(userPassword)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                println("error=\(error)")
                return
            }
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data , options: .MutableContainers, error: &err) as? NSDictionary
            
            if let parseJSON = json {
                var resultValue = parseJSON["status"] as? String
                println("result: \(resultValue)")
                
                
                var messageToDisplay:String = parseJSON["message"] as! String // Use to display biz logic error from Server side. 
                
                
                // Use dispatch_sync() to display error message thrown from server side.
                dispatch_sync(dispatch_get_main_queue(), {
                    
                    if (resultValue == "Success") {
                        // Login is successful, set a flag at here so that user don't have to log in again in Protected View.
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        let viewMapPosts = self.storyboard?.instantiateViewControllerWithIdentifier("viewPostMap2") as! PostsMapViewController
                        // Show the new view with inherited frame, like navigation controller.
//                        self.navigationController?.pushViewController(viewMapPosts, animated: true)
                        
                        // Show the new view withou the inherited frame, like navigation controller.
                        self.presentViewController(viewMapPosts, animated: true, completion: nil)
                        
                    } else {
                        // Display alert message with confirmation.
                        self.displayMyAlertMessage(messageToDisplay)
                    }
                    
                })
                

            }
        }
        task.resume()
        
    }
    
    @IBAction func toTheMapButtonTapped(sender: AnyObject) {
        let mapPostsView = self.storyboard!.instantiateViewControllerWithIdentifier("postMapView1") as! PostsMapViewController
        self.navigationController!.pushViewController(mapPostsView, animated: true)
        
    }
    
    // Display prompt
    func displayMyAlertMessage(userMessage: String) {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

}
