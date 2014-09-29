//
//  TwittViewController.swift
//  TwitterMobile
//
//  Created by Scott Liu on 9/26/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tweet = User.currentUser!.current_Tweet
        User.currentUser!.current_Tweet = nil
        
    }

    @IBAction func reply(sender: AnyObject) {
        User.currentUser?.current_Tweet = tweet
        self.performSegueWithIdentifier("TweetDetailToReplyRetweet", sender: self)
    }
    
    @IBAction func back(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
