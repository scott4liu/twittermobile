//
//  ViewController.swift
//  TwitterMobile
//
//  Created by Scott Liu on 9/26/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

let image_favorite_on = UIImage(named: "like_on.png");
let image_favorite_off = UIImage(named: "like_off.png");
let image_retweet_on = UIImage(named: "retweet_on.png");
let image_retweet_off = UIImage(named: "retweet_off.png");

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?
    var prototypeCell: TweetTableViewCell?
    
    var refreshControl: UIRefreshControl!
    

    @IBOutlet weak var tweetsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading Tweets ...")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tweetsTableView.addSubview(refreshControl)
        
        //for ios 8.0
        //tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        loadHomeTimeline(nil)
       
    }
    
    func loadHomeTimeline(parameters: NSDictionary?)
    {
        TwitterClient.sharedInstance.loadHomeTimeline(parameters){ (tweetArray, error) -> () in
            if (tweetArray != nil) {
                if parameters != nil && self.tweets != nil {
                    for each in tweetArray! {
                        self.tweets!.append(each)
                    }
                } else {
                    self.tweets = tweetArray
                }
                self.tweetsTableView.reloadData()
            } else {
                println(error)
            }
        }
    }
    
    func refresh(sender:AnyObject)
    {
        loadHomeTimeline(nil)
        self.refreshControl.endRefreshing()
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
            
            if tweet.retweeted_status != nil {
                cell.reTweetBy.text = "@" + tweet.user!.screenname!+" retweeted"
                cell.topSpaceConstraint.constant = 18
                dispalyTweet(cell, tweet: tweet.retweeted_status!)
            } else {
                cell.reTweetBy.text = ""
                cell.topSpaceConstraint.constant = 3
                dispalyTweet(cell, tweet: tweet)
            }
            
            
            showFavoriteBtn(cell, tweet:tweet)
            
            showRetweetBtn(cell, tweet:tweet)
            
            cell.timeLabel.text = tweet.timeIntervalAsStr
            
            //infinite scroll
            if (indexPath.row == (self.tweets!.count-1) ) {
                let parameters = ["max_id": tweet.id, "count": 20]
                loadHomeTimeline(parameters)
            }
        }

        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.index = indexPath.row
        
        return cell
    }
    
    func showRetweetBtn(cell: TweetTableViewCell, tweet: Tweet){
        if (tweet.retweeted) {
            cell.retweetButton.setImage(image_retweet_on, forState: .Normal)
        } else {
            cell.retweetButton.setImage(image_retweet_off, forState: .Normal)
        }
        
        cell.retweetButton.setTitle(" "+String(tweet.retweet_count ?? 0), forState: .Normal)
    }
    
    func showFavoriteBtn(cell: TweetTableViewCell, tweet: Tweet){
        if (tweet.favorited) {
            cell.favoriteButton.setImage(image_favorite_on, forState: .Normal)
        } else {
            cell.favoriteButton.setImage(image_favorite_off, forState: .Normal)
        }
        cell.favoriteButton.setTitle(" "+String(tweet.favorite_count ?? 0), forState: .Normal)
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
            
            let tweet = self.tweets![cell.index!]
            if !tweet.favorited {
                tweet.favorite()
                showFavoriteBtn(cell, tweet:tweet)
            }
        }
    }
    
    @IBAction func replyToTweet(sender: AnyObject) {
        let btn = sender as UIButton
        if let cell = btn.superview?.superview?.superview as? TweetTableViewCell {
            let tweet = self.tweets![cell.index!]
            
            User.currentUser?.current_Tweet = tweet
            
            self.performSegueWithIdentifier("HomeToNewTweet", sender: self)
        }
        
    }
    
    @IBAction func reTweet(sender: AnyObject) {
        let btn = sender as UIButton
        if let cell = btn.superview?.superview?.superview as? TweetTableViewCell {
            
            let tweet = self.tweets![cell.index!]
            if !tweet.retweeted {
                tweet.reTweet()
                showRetweetBtn(cell, tweet:tweet)
            }
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let tweet = tweets?[indexPath.row] {
            User.currentUser?.current_Tweet = tweet
            self.performSegueWithIdentifier("HomeTimelineToOneTweet", sender: self)
        }
    }
}

