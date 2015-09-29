//
//  RegisterViewController.swift
//  OoOsers
//
//  Created by Wei Wu on 8/30/15.
//  Copyright (c) 2015 ooosers. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userEmailTextfield: UITextField!
    @IBOutlet weak var userPasswordTextfield: UITextField!
    @IBOutlet weak var rePasswordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextfield.text
        let userPassword = userPasswordTextfield.text
        let userRePassword = rePasswordTextfield.text
        
        // Check for empty fields.
        if (userEmail.isEmpty || userPassword.isEmpty ||
            userRePassword.isEmpty) {
            // Display alert message.
            displayMyAlertMessage("All fields are required!")
            return
        }
        
        // Check if passwords match.
        if (userRePassword != userPassword) {
            // Display an alert message.
            displayMyAlertMessage("Passwords do not match!")
            return
        }
        
        // Store data locally this time. It Only can store one user profile at a time. For testing Usage.
//        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "userEmail")
//        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword")
//        NSUserDefaults.standardUserDefaults().synchronize()
        
        // Send user data to server side
        let myUrl = NSURL(string: "http://www.ooosers.com/ooosers/tests/iOSusages/userRegister.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "email=\(userEmail)&password=\(userPassword)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
//            println(response)
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
            
            if let parseJSON = json {
                var resultValue = parseJSON["status"] as? String
                println("result: \(resultValue)")
                
                var isUserRegistered:Bool = false
                if (resultValue == "Success") { isUserRegistered = true }
                
                var messageToDisplay:String = parseJSON["message"] as! String
                if (!isUserRegistered) {
                    messageToDisplay = parseJSON["message"] as! String
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    // Display alert message with confirmation.
                    var myAlert = UIAlertController(title: "Alert", message: messageToDisplay,
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style:UIAlertActionStyle.Default) {
                        action in
                        if (resultValue == "Success") {
                            self.dismissViewControllerAnimated(true, completion: nil)
                            // back to the previous view controller
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }
                    
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                
                })
                
                
            }
        }
        
        task.resume()
        
        
        
        
        
        // Display alert message with confirmation. For Locally testing use.
//        var myAlert = UIAlertController(title: "Alert", message: "Registration is successful. Thank you!", preferredStyle:UIAlertControllerStyle.Alert)
//        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default) { action in
//            
//            self.dismissViewControllerAnimated(true, completion: nil)
//        
//        }
//        
//        myAlert.addAction(okAction)
//        self.presentViewController(myAlert, animated:true, completion: nil)
        
    }
    
    func displayMyAlertMessage(userMessage: String) {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func toMapTappedin(sender: AnyObject) {
        let mapPostsView = self.storyboard!.instantiateViewControllerWithIdentifier("postMapView1") as! PostsMapViewController
        self.navigationController!.pushViewController(mapPostsView, animated: true)
    }
    
    
    
    


}
