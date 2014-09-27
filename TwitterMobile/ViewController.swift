//
//  ViewController.swift
//  TwitterMobile
//
//  Created by Scott Liu on 9/26/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LoginCompleteHandler {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        TwitterClient.sharedInstance.login(self)
        
    }

    func login_succeed() {
        
        TwitterClient.sharedInstance.loadHomeTimeline()
        
    }
    func login_failed(error: NSError!) {
        NSLog("Failed to login: \(error)")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwittTableViewCell") as TwittTableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
}

