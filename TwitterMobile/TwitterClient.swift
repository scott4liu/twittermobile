//
//  TwitterClient.swift
//  TwitterMobile
//
//  Created by Scott Liu on 9/26/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

let twitterAPIKey = "xH4RxS5LUUwtmW8F6kZoZNxMC"
let twitterAPISecret = "c3a9e9EH4amkNJqnqtzoG8Op1EiiH3Evm2cssTZGFPOiLp7xoj"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

protocol LoginCompleteHandler {
    func login_succeed()
    func login_failed(error: NSError!)
}

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var postLoginHandler: LoginCompleteHandler?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterAPIKey, consumerSecret: twitterAPISecret)
        }
        return Static.instance
    }
    
    //step 1, 2
    func login(postHandler: LoginCompleteHandler) {
        
        self.postLoginHandler = postHandler
        
        //OAuth 6 steps
        requestSerializer.removeAccessToken()
        
        //step 1
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            println("got request token: \(requestToken)")
            
            //step 2
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL);
            
            }) { (error: NSError!) -> Void in
                println("error requesting request token: \(error)")
        }
    }
    
    //step 3
    func handleReturnFormUserAuthorization(queryString: String){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: queryString),
            success: { (accessToken: BDBOAuthToken!) -> Void in
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                NSLog("got accessToken: \(accessToken)")
                self.loadAccount()
                self.postLoginHandler?.login_succeed()
            })
            { (error: NSError!) -> Void in
                NSLog("Failed to get Access Token: \(error)")
        }

    }
    
    
    func loadAccount()
    {
        self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response) -> Void in
            println(response)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.postLoginHandler?.login_failed(error)
                ()
        })

    }
    
    func loadHomeTimeline(){
        
        self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response) -> Void in
            println(response)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error);
        })

    }
    
    
    
}

