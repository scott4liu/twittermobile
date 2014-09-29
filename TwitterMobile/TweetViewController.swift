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
    
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var reTweetBy: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var reTweetCount: UILabel!
    
    @IBOutlet weak var favoriteCount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tweet = User.currentUser!.current_Tweet
        User.currentUser!.current_Tweet = nil
        
        if self.tweet.retweeted_status != nil {
            self.reTweetBy.text = "@" + tweet.user!.screenname!+" retweeted"
            dispalyTweet(self.tweet.retweeted_status!)
        } else {
            self.reTweetBy.text = ""
            dispalyTweet(self.tweet)
        }
        
        showFavoriteBtn()
        
        showRetweetBtn()

        
    }
    
    func showFavoriteBtn(){
        if (tweet.favorited) {
            favoriteButton.setImage(image_favorite_on, forState: .Normal)
        } else {
            favoriteButton.setImage(image_favorite_off, forState: .Normal)
        }
        favoriteCount.text = String(tweet.favorite_count ?? 0)
    }

    
    func showRetweetBtn(){
        if (self.tweet.retweeted) {
            self.retweetButton.setImage(image_retweet_on, forState: .Normal)
        } else {
            self.retweetButton.setImage(image_retweet_off, forState: .Normal)
        }
        
        reTweetCount.text = String(tweet.retweet_count ?? 0)
        
    }

    
    func dispalyTweet(tweet: Tweet){
        
        tweetText.text = tweet.text
        
        self.nameLabel.text = tweet.user?.name
        self.screenName.text = "@" + tweet.user!.screenname!
        
        let layer = self.avatarImageView.layer
        layer.masksToBounds=true
        layer.cornerRadius=8.0
        
        if let imageURL: String = tweet.user?.profileImageURL {
            
            self.avatarImageView.setImageWithURL(NSURL(string: imageURL))
            
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        timeStampLabel.text = dateFormatter.stringFromDate(tweet.createdAt!)
        
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
