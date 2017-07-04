//
//  TweetsViewController.swift
//  ZippyBird
//
//  Created by Vader1359 on 7/3/17.
//  Copyright © 2017 Vader1359. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    // List of Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // List of Actions
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        twitterClient?.logout()
        let loginVC = storyboard!.instantiateInitialViewController() as! UIViewController
        self.navigationController?.present(loginVC, animated: true, completion: nil)
        
    }
    
    @IBAction func onCompose(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goComposeTweetvc", sender: nil)
        
    }
    
    // List of global variables
    let twitterClient = TwitterClient.sharedTwitterClient
    var tweets = [Tweet]()
    var tweetToDetails = Tweet(dictionary: [:])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        // Fetch tweets information
        
        twitterClient?.getHomeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
    }
    
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        twitterClient?.getHomeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        print("List updated")
        self.tableView.reloadData()
        
        refreshControl.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetailsvc" {
            if let nextVC = segue.destination as? DetailsViewController {
                   nextVC.tweet = tweetToDetails
                
            }
        }
        
        
        
        
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

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetCell
        cell.tweet = self.tweets[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedTweet = tweets[indexPath.row]
        self.tweetToDetails = selectedTweet as! Tweet
        
        performSegue(withIdentifier: "goDetailsvc", sender: nil)
    }
    
    
}
