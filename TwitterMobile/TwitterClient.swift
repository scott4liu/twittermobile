//
//  TwitterClient.swift
//  TwitterMobile
//
//  Created by Scott Liu on 9/26/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

let twitterAPIKey = "xH4RxS5LUUwtmW8F6kZoZNxMC"
let twitterAPISecret = "c3a9e9EH4amkNJqnqtzoG8Op1EiiH3Evm2cssTZGFPOiLp7xoj"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

protocol LoginCompleteHandler {
    func login_succeed()
    func login_failed(error: NSError!)
}

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var postLoginHandler: LoginCompleteHandler?
    
    //var
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterAPIKey, consumerSecret: twitterAPISecret)
        }
        return Static.instance
    }
    
    func logout() {
        User.currentUser = nil
        
        self.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    /* closure style complete handling
    
    var completeHandler: ( (user: User?, error: NSError?)->() )?
    func loginWithCompleteHandlingBlock(completeHandler: (user: User?, error: NSError?)->() ) {
        self.completeHandler = completeHandler
        
    }
    
    */
    
    //step 1, 2
    func login(postHandler: LoginCompleteHandler) {
        
        self.postLoginHandler = postHandler
        
        //OAuth 6 steps
        
        //step 1
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            println("got request token: \(requestToken)")
            
            //step 2
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL);
            
            }) { (error: NSError!) -> Void in
                NSLog("error requesting request token: \(error)")
                self.postLoginHandler?.login_failed(error)
        }
    }
    
    //step 3: get Access Token
    func openURL(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query!),
            success: { (accessToken: BDBOAuthToken!) -> Void in
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                NSLog("got accessToken: \(accessToken)")
                self.loadCurrentUser( )
            })
            { (error: NSError!) -> Void in
                NSLog("Failed to get Access Token: \(error)")
                self.postLoginHandler?.login_failed(error)
        }

    }
    
    
    func loadCurrentUser()
    {
        self.GET("1.1/account/verify_credentials.json", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response) -> Void in
                let user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)
                self.postLoginHandler?.login_succeed()
                
            
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.postLoginHandler?.login_failed(error)
                ()
        })

    }
    
    func loadHomeTimeline(parameters: NSDictionary?, complete: (tweets: [Tweet]?, error: NSError? )->()  ){
        
        self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response) -> Void in
              var tweets = Tweet.tweetsFromArray(response as [NSDictionary])
              complete(tweets: tweets, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
              complete(tweets: nil, error: error)
        })

    }
    
    
    
}

