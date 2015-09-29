//
//  ViewController.swift
//  OoOsers
//  Because we use the CLLocationManager, so we need to inherit a class called CLLocationManagerDelegate
//
//  Created by Wei Wu on 8/27/15.
//  Copyright (c) 2015 OoOsers. All rights reserved.
//

import UIKit
import MapKit

class PostsMapViewController: UIViewController, CLLocationManagerDelegate {
    
    // Define a Location manager, where we use the apple call the location manager. This is going to be a property. It has to be initiated otherwise would be a nil error thrown.
    var coreLocationManager = CLLocationManager()
    
    
    // Use LocationManager class downloaded from Github repository with a property defined.
    var locationManager: LocationManager!

    @IBOutlet weak var mapView: MKMapView! // need to import MapKit reference.
  //    @IBOutlet weak var locationInfo: UILabel!
    
//    @IBAction func updateLocationButton(sender: AnyObject) {
//        getLocation()
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        coreLocationManager.delegate = self
        // To get the LocationManager up and running
        locationManager = LocationManager.sharedInstance
        
        
        // 1. Ask users for the authorization to use the their locations, so, we defined a constant on here with CLLocationManager's property to get a status of Authorization
        let authorizationCode = CLLocationManager.authorizationStatus()
        // 2. See if the user allows our app to use he or she location, if it's not determined, then, we can actually ask for her or his specific authorization status, which means that either always allowed, or only when in use. Once the user give the determination at the first time, then the first part of if statement won't be executed again.
        if authorizationCode == CLAuthorizationStatus.NotDetermined &&
        (coreLocationManager.respondsToSelector("requestAlwaysAuthorization") ||
            coreLocationManager.respondsToSelector("requestWhenInUseAuthorization")) {
            if ( NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil ) {
                coreLocationManager.requestAlwaysAuthorization()
            } else {
                // Simple solution when the key dictionary is not available.
                println("No description provided!!!");
            }
    
        } else {
            getLocation()
        }
    }
    
    // Before we implement this function, we have to define and initialize a property LocationManager downloaded, a third party api in function viewDidLoad
    func getLocation() {
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            // Simply to create CLLocation object with latitude and longitude.
            self.displayLocation(CLLocation(latitude: latitude, longitude: longitude))
        }
    }
    
    func displayLocation(location:CLLocation) {
        // 1. Use the mapView property to display the place in order to have proper area displayed on the screen.
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpanMake(0.62, 0.62)), animated: true)
        
        // 2. To set the red pin so as to set an exact location where we are at.
        let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // 3. To set up the point out location.
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoord
        annotation.title = "My Place"
        annotation.subtitle = "Luna Rossa"
        // 4. Simply add the annotation to the MapView with addAnnotation function
        mapView.addAnnotation(annotation)
        // 5. Set a bunch of pins on the map view, like sushi, bars, clubs and so on in the region that we just set earlier. But, in here, we only set a place for demonstration
        mapView.showAnnotations([annotation], animated: true)
        
        // reverse the coordination into the exact format of address.
//        locationManager.reverseGeocodeLocationWithCoordinates(location, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
//            // Use the keyword "as" to cast the object into the type String.
//            let address = reverseGecodeInfo?.objectForKey("formattedAddress") as! String
//            self.locationInfo.text = address
//        })
        
    }
    
    // Use the delegation of location Manager to check the user's determination status in order to display the location pin on the screen.
//    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        // if the status of authorization is changed and is not determined, not denied and not restricted, and then we can get the location.
//        if status != CLAuthorizationStatus.NotDetermined ||
//        status != CLAuthorizationStatus.Denied ||
//            status != CLAuthorizationStatus.Restricted {
//                getLocation()
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutButtonTappedin(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.dismissViewControllerAnimated(true, completion: nil)
        

        let storyBoard1 : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewMapPosts = storyBoard1.instantiateViewControllerWithIdentifier("postMapView1") as! PostsMapViewController
        // Show the new view with inherited frame, like navigation controller.
        //                        self.navigationController?.pushViewController(viewMapPosts, animated: true)
        
        // Show the new view withou the inherited frame, like navigation controller.
        self.presentViewController(viewMapPosts, animated: true, completion: nil)
        
        
        
    
        
    }

}

