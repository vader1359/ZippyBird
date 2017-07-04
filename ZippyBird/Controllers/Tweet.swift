//
//  Tweet.swift
//  ZippyBird
//
//  Created by Vader1359 on 7/3/17.
//  Copyright © 2017 Vader1359. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class Tweet: NSObject {
    var text: String?
    var username: String?
    var userProfileImgURL: URL?
    var timestamp: String?
    var tweetId: Int?
    
    init(dictionary: NSDictionary) {
        tweetId = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        timestamp = dictionary["created_at"] as? String
        if let userDictionary = dictionary["user"] as? NSDictionary {
            username = userDictionary["name"] as? String
            
            if let userProfileImgURLString = userDictionary["profile_image_url"] as? String {
                userProfileImgURL = URL(string: userProfileImgURLString) as? URL
            }
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
        
        
    }

}
