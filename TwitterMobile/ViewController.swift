//
//  ViewController.swift
//  TwitterMobile
//
//  Created by Scott Liu on 9/26/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?

    @IBOutlet weak var tweetsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        TwitterClient.sharedInstance.loadHomeTimeline(nil){ (tweets, error) -> () in
            if (tweets != nil) {
                self.tweets = tweets
                self.tweetsTableView.reloadData()
            }
        }
    }

    @IBAction func logout(sender: AnyObject) {
        
        TwitterClient.sharedInstance.logout()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell") as TweetTableViewCell
        
        cell.tweetText.text = tweets?[indexPath.row].text
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.tweets != nil) {
            return self.tweets!.count;
        } else {
            return 0
        }
    }
    
    
    
}

