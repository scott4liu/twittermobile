//
//  LoginViewController.swift
//  TwitterMobile
//
//  Created by Scott Liu on 9/27/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginCompleteHandler {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func login(sender: AnyObject) {
        TwitterClient.sharedInstance.login(self)
    }
    
    func login_succeed() {
        
        println("login succeed, user: \(User.currentUser!.name)")
        
        
        //TwitterClient.sharedInstance.loadHomeTimeline()
        
        self.performSegueWithIdentifier("LoginSeque", sender: self)
        
        
    }
    func login_failed(error: NSError!) {
        NSLog("Failed to login: \(error)")
    }

    

}
