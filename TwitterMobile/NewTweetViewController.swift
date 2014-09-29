//
//  NewTwittViewController.swift
//  TwitterMobile
//
//  Created by Scott Liu on 9/27/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var avatorImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    var reply_to_tweet: Tweet?
    
    @IBOutlet weak var replyToLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reply_to_tweet = User.currentUser!.current_Tweet
        User.currentUser!.current_Tweet = nil

        if (reply_to_tweet != nil) {
            replyToLabel.text = "Reply to: @\(reply_to_tweet!.user!.screenname!)"
        }
        else {
            replyToLabel.text = ""
        }
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
        let str = tweetTextView.text
        if countElements(str) > 0 {
            TwitterClient.sharedInstance.postTweet(str, in_reply_to_status_id: reply_to_status_id) { (tweet, error) -> () in
                if (tweet != nil) {
                    //User.currentUser!.current_Tweet = tweet
                    self.performSegueWithIdentifier("NewTweetToHome", sender: self)
                } else {
                    NSLog("Failed to post tweet: \(error)")
                }
            }
        }
        
    }
    
    func textViewDidChange(textView: UITextView){
        self.countLabel.text = String(140-countElements(textView.text))
    }
}
