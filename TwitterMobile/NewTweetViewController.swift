//
//  NewTwittViewController.swift
//  TwitterMobile
//
//  Created by Scott Liu on 9/27/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var avatorImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    var reply_to_tweet: Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reply_to_tweet = User.currentUser!.current_Tweet
        User.currentUser!.current_Tweet = nil

        nameLabel.text = User.currentUser!.name
        screenNameLabel.text = "@" + User.currentUser!.screenname!
        
        let layer = avatorImageView.layer
        layer.masksToBounds=true
        layer.cornerRadius=8.0
        
        if let imageURL: String = User.currentUser!.profileImageURL {
            
            avatorImageView.setImageWithURL(NSURL(string: imageURL))
            
        }
        
    }

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func postTweet(sender: AnyObject) {
        let reply_to_status_id = self.reply_to_tweet?.id
        TwitterClient.sharedInstance.postTweet(tweetTextView.text, in_reply_to_status_id: reply_to_status_id) { (tweet, error) -> () in
            if (tweet != nil) {
                User.currentUser!.current_Tweet = tweet
                self.performSegueWithIdentifier("NewTweetToTweet", sender: self)
            } else {
                NSLog("Failed to post tweet: \(error)")
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
