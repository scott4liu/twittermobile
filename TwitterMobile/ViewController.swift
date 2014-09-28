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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell") as TweetTableViewCell
        
        if let tweet = tweets?[indexPath.row] {
            cell.tweetText.text = tweet.text
            
            cell.nameLabel.text = tweet.user?.name
            cell.screenName.text = "@" + tweet.user!.screenname!
        
            let layer = cell.avatarImageView.layer
            layer.masksToBounds=true
            layer.cornerRadius=8.0
        
            if let imageURL: String = tweets?[indexPath.row].user?.profileImageURL {
            
                cell.avatarImageView.setImageWithURL(NSURL(string: imageURL))
            
            }
            
            
            cell.favoriteButton.setTitle(" "+String(tweet.favorite_count ?? 0), forState: .Normal)
            cell.retweetButton.setTitle(" "+String(tweet.retweet_count ?? 0), forState: .Normal)
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
        //1 line: 85
        //2 lines:  97 --105
        //3 lines: 109
        //4 lines: 121
        var line: Int = 0
        if let tweet = tweets?[indexPath.row] {
            line = tweet.text_length/36
        }
        
        return CGFloat(81+line*12);
    }
    
    @IBAction func likeTheTweet(sender: AnyObject) {
        
        let btn = sender as UIButton
        if let cell = btn.superview?.superview?.superview as? TweetTableViewCell {
            println(cell.index)
        }
    }
    
}

