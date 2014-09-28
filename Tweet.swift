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
    var favorite_count: Int?
    var retweet_count: Int?
    var text_length : Int = 0
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        text = dictionary["text"] as? String
        
        if (text != nil) {
            text_length = countElements(text!)
        }
        
        favorite_count = dictionary["favorite_count"] as Int?
        retweet_count = dictionary["retweet_count"] as Int?
        
        user = User(dictionary: dictionary["user"] as NSDictionary)
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
    }
    
    class func tweetsFromArray(array: [NSDictionary])->[Tweet] {
        var tweets = [Tweet]()
        
        for dict in array {
            tweets.append(Tweet(dictionary: dict))
        }
        
        return tweets
    }
    

   
}
