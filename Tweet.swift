//
//  Twitt.swift
//  TwitterMobile
//
//  Created by Scott Liu on 9/27/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var dictionary: NSDictionary?
    var favorite_count: Int = 0
    var retweet_count: Int = 0
    var text_length : Int = 0
    var retweeted: Bool = false
    var favorited: Bool = false
    var retweeted_status: Tweet?
    var id: Int = 0
    
    class func tweetsFromArray(array: [NSDictionary])->[Tweet] {
        var tweets = [Tweet]()
        
        for dict in array {
            tweets.append(Tweet(dictionary: dict))
        }
        
        return tweets
    }
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        text = dictionary["text"] as? String
        
        if (text != nil) {
            text_length = countElements(text!)
        }
        
        favorite_count = dictionary["favorite_count"] as Int
        retweet_count = dictionary["retweet_count"] as Int
        
        user = User(dictionary: dictionary["user"] as NSDictionary)
        createdAtString = dictionary["created_at"] as? String
        
        favorited = dictionary["favorited"] as Bool
        retweeted = dictionary["retweeted"] as Bool
        if let retweet_dic = dictionary["retweeted_status"] as? NSDictionary {
            retweeted_status = Tweet(dictionary: retweet_dic)
        }
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        id = dictionary["id"] as Int
        
    }
    
    
    var timeIntervalAsStr: String {
        get {
            let now = NSDate()
            let t = now.timeIntervalSinceDate(self.createdAt!)
            let d: Int = Int(t)/86400
            if d > 0 {
                return "\(d)d"
            } else {
                let h: Int = Int(t)/3600
                if h>0 {
                    return "\(h)h"
                } else {
                    let m: Int = Int(t)/60
                    return "\(m)m"
                }
            }

        }
    }
    
    func reTweet()
    {
        self.retweeted = true
        self.retweet_count++
        TwitterClient.sharedInstance.reTweet(self.id, complete: { (tweet, error) -> () in
            if error != nil {
                NSLog("Failed to reTweet: \(error)")
                self.retweeted = false
                self.retweet_count--
            }
        })
    }
    
    func favorite()
    {
        self.favorited = true
        self.favorite_count++
        TwitterClient.sharedInstance.favoriteTweet(self.id, complete: { (tweet, error) -> () in
            if error != nil {
                NSLog("Failed to favorite tweet: \(error)")
                self.favorited = false
                self.favorite_count--
            }
        })
        
    }
    
    

   
}
