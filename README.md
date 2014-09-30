# TwitterMobile - Twitter Mobile Client

This is an ios mobile app for Twitter using the [Twitter API](https://dev.twitter.com/overview/documentation). 

Time spent: 20 hours spent in total

Completed user stories:

* User can sign in using OAuth login flow
* User can view last 20 tweets from their home timeline
* The current signed in user is persisted across restarts
* In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. Designed the custom cell with the proper Auto Layout settings. Implemented model and API classes to support UI display and interactions
* User can pull to refresh
* User can compose a new tweet by tapping on a New or Reply button.
* User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
* When composing, you should have a countdown in the upper right for the tweet limit.
* After creating a new tweet, a user can view it in the timeline immediately without refetching the timeline from the network.
* Retweeting and favoriting should increment the retweet and favorite count.
* User can unfavorite and it will decrement the favorite count.
* Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
* User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.


Walkthrough of all user stories:

![Video Walkthrough](TwitterMobileDemo.gif)

GIF created with LiceCap (http://www.cockos.com/licecap/) .
 