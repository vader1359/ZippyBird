//
//  TwitterClient.swift
//  ZippyBird
//
//  Created by Vader1359 on 7/3/17.
//  Copyright © 2017 Vader1359. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let baseUrl = URL(string: "https://api.twitter.com/")
let consumerKey = "Wya2jzJIAqGh5lyHXccb5APYE"
let consumerSecret = "KaBK9UoRsqmsZRrHJBFljsHnBf9acUM7xwQ61oWpZ9xcmL8YQ4"




class TwitterClient: BDBOAuth1SessionManager {
    
    var window: UIWindow!
    
    // Handle API required info
    static let sharedTwitterClient = TwitterClient(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    // This closure variable is used to store the progress of success/failure
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    // Functions to handle HTTP GET methods
    // GET myAccount
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        // As the login progress has 2 parts, requestToken and accessToken. During the requestToken part, the login is still not fully successful but only partly successful. However, the accessToken part is done in a different screen (in AppDelegate after the app turn back from UserAuthorization). Therefore, the ongoing progress need to be stored in variables.
        
        // Store the current success/failure progress to the global variable
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        // The path here becaused we already set the baseURL in twitterClient
        // -> URL = baseURL + path
        fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: "zippybird://"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            // With this, we get back the requestToken
            if let requestToken = requestToken {
                print("requestToken: \(requestToken.token)")
                
                // This is the URL form twitter to authorize the app
                let authUrl = URL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(requestToken.token!)")!
                // Open the URL with Safari to let user authorize the app.
                UIApplication.shared.open(authUrl, options: [:], completionHandler: nil)
            }

        }, failure: { (error: Error?) in
            print("\(error?.localizedDescription)")
            // However, if the progress failed here, we can call the login failure
            self.loginFailure?(error!)
        })
    }
    
    func continueAccessTokenPartWithURL(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            
            // At this point, we are already logged in
            
            // Call the getMyAccount to get the Current Account then save it to _myUser
            self.getMyAccount(success: { (user: User) in
                User.myUser = user
                
                self.loginSuccess?()
                print("Login successfully")
            }, failure: { (error: Error) in
                
                print(error.localizedDescription)
                self.loginFailure?(error)
            })
            
            
            
            }, failure: { (error: Error?) in
                print(error?.localizedDescription)
                self.loginFailure?(error!)
            })
    }
    
    func logout() {
    
        deauthorize()
        User.myUser = nil

    }
    
    // HANDLE HTTP GET METHODS
    
    func getMyAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (response: URLSessionDataTask, data: Any?) in
            if let data = data {
                let myUserData = data as! NSDictionary
                let myUser = User(dictionary: myUserData)
                success(myUser)
                
            }
            
        }, failure: { (response: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    // GET homeTimeline
    
    func getHomeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {

        get("1.1/statuses/home_timeline.json", parameters: nil, success: { (task: URLSessionDataTask, data: Any?) in
            var tweetsData = data as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetsData)
            success(tweets)
            
            
        }, failure: { (response: URLSessionDataTask?, error: Error!) in
            failure(error)
        })
    }
    
    // HANDLE HTTP POST METHODS
    
    func postStatus(status: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let parameter = ["status": status]
        
        TwitterClient.sharedTwitterClient?.post("1.1/statuses/update.json", parameters: parameter, progress: nil, success: { (task: URLSessionDataTask, data: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask, error: Error) in
            failure(error)
            } as? (URLSessionDataTask?, Error) -> Void)
    }
    
    func postFavorite(statusId: Int, success: @escaping() -> (), failure: @escaping(Error) -> ()) {
        let parameter = ["id":statusId]
        
        TwitterClient.sharedTwitterClient?.post("1.1/favorites/create.json", parameters: parameter, progress: nil, success: { (task: URLSessionDataTask, data: Any?) in
            
            success()
        }, failure: { (task: URLSessionDataTask, error: Error) in
            failure(error)
            } as? (URLSessionDataTask?, Error) -> Void)
    }
    
    func postRetweet(statusId: Int, success: @escaping() -> (), failure: @escaping(Error) -> ()) {
        
        
        TwitterClient.sharedTwitterClient?.post("1.1/statuses/retweet/\(statusId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, data: Any?) in
            print(task)
            success()
        }, failure: { (task: URLSessionDataTask, error: Error) in
            failure(error)
            } as? (URLSessionDataTask?, Error) -> Void)
    }
    

}
