//
//  User.swift
//  ZippyBird
//
//  Created by Vader1359 on 7/3/17.
//  Copyright © 2017 Vader1359. All rights reserved.
//

import UIKit

class User: NSObject {
    var username: String?
    var profileImgURL: URL?
    var tagline: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        username = dictionary["name"] as? String
        tagline = dictionary["description"] as? String
        
        if let profileImgURLString = dictionary["profile_background_image_ur"] as? String {
            profileImgURL = URL(string: profileImgURLString)
        }
        
    }
    
    static var _myUser: User?
    class var myUser: User? {
        // Getter and Setter?
        get {
            if _myUser == nil {
                let defaults = UserDefaults.standard
                let myUserData = defaults.object(forKey: "myUserData") as? NSData
                
                if let myUserData = myUserData {
                    do {
                    let dictionary = try JSONSerialization.jsonObject(with: myUserData as Data, options: []) as! NSDictionary
                    _myUser = User(dictionary: dictionary)
                    } catch {
                        print("There was an error")
                    }
                }
            }
            return _myUser
        }
        
        set(myUser) {
            _myUser = myUser
            let defaults = UserDefaults.standard
            
            if let myUser = myUser {
                let myUserData = try! JSONSerialization.data(withJSONObject: myUser.dictionary!, options: [])
                
                defaults.set(myUserData, forKey: "myUserData")
            } else {
                defaults.set(nil, forKey: "myUserData")
            }
            
            defaults.synchronize()
        }
    }
    
}
