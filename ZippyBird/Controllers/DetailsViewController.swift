//
//  DetailsViewController.swift
//  ZippyBird
//
//  Created by Vader1359 on 7/4/17.
//  Copyright © 2017 Vader1359. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // List of Outlets
    @IBOutlet weak var tweetLabel: UILabel!
    
    // List of Actions
    @IBAction func onRetweet(_ sender: UIButton) {
        TwitterClient.sharedTwitterClient?.postRetweet(statusId: tweet.tweetId!, success: {
            print("Retweeted")
        }, failure: { (error) in
            print(error.localizedDescription)
        })
        
    }
    @IBAction func onFavorite(_ sender: UIButton) {
        TwitterClient.sharedTwitterClient?.postFavorite(statusId: tweet.tweetId!, success: {
            print("Liked")
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    // List of global variables
    
    var tweet = Tweet(dictionary: [:])

    override func viewDidLoad() {
        super.viewDidLoad()

        tweetLabel.text = tweet.text

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
