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
    var prototypeCell: TweetTableViewCell?

    @IBOutlet weak var tweetsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tweetsTableView.rowHeight = UITableViewAutomaticDimension
       
        TwitterClient.sharedInstance.loadHomeTimeline(nil){ (tweets, error) -> () in
            if (tweets != nil) {
                self.tweets = tweets
                
                //println(tweets![0].dictionary)
                self.tweetsTableView.reloadData()
            }
        }
    }

    @IBAction func logout(sender: AnyObject) {
        
        TwitterClient.sharedInstance.logout()
        
    }
    
    func dispalyTweet(cell: TweetTableViewCell, tweet: Tweet){
        
        cell.tweetText.text = tweet.text
        
        cell.nameLabel.text = tweet.user?.name
        cell.screenName.text = "@" + tweet.user!.screenname!
        
        let layer = cell.avatarImageView.layer
        layer.masksToBounds=true
        layer.cornerRadius=8.0
        
        if let imageURL: String = tweet.user?.profileImageURL {
            
            cell.avatarImageView.setImageWithURL(NSURL(string: imageURL))
            
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell") as TweetTableViewCell
        
        if let tweet = tweets?[indexPath.row] {
            
            println("******************")
            println(tweet.dictionary)
            
            if tweet.retweeted_status != nil {
                cell.reTweetBy.text = "@" + tweet.user!.screenname!+" retweeted"
                cell.topSpaceConstraint.constant = 18
                dispalyTweet(cell, tweet: tweet.retweeted_status!)
            } else {
                cell.reTweetBy.text = ""
                cell.topSpaceConstraint.constant = 3
                dispalyTweet(cell, tweet: tweet)
            }
            
            cell.favoriteButton.setTitle(" "+String(tweet.favorite_count ?? 0), forState: .Normal)
            cell.retweetButton.setTitle(" "+String(tweet.retweet_count ?? 0), forState: .Normal)
            
            cell.timeLabel.text = tweet.timeIntervalAsStr
        }

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.tweets != nil) {
            return self.tweets!.count;
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var baseHight :CGFloat = 70.0;
        
        var line: Int = 0
        if let tweet = tweets?[indexPath.row] {
            if tweet.retweeted_status != nil {
                baseHight = 85.0
            }
            line = tweet.text_length/36
        }
        baseHight = baseHight + 12.0*CGFloat(line)
        
        return CGFloat(baseHight);
    }
    
    @IBAction func likeTheTweet(sender: AnyObject) {
        
        let btn = sender as UIButton
        if let cell = btn.superview?.superview?.superview as? TweetTableViewCell {
            println(cell.index)
        }
    }
    
}

