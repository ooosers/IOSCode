//
//  AddPostViewController.swift
//  OoOsers
//
//  Created by Wei Wu on 8/28/15.
//  Copyright (c) 2015 ooosers. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func toPostMapViewTappedin(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
