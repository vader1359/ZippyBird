//
//  WallViewController.swift
//  ZippyBird
//
//  Created by Vader1359 on 6/28/17.
//  Copyright © 2017 Vader1359. All rights reserved.
//

import UIKit
import ReachabilitySwift
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    // List of Outlets
    
    // List of Actions
    @IBAction func onLogin(_ sender: UIButton) {
        let twitterClient = TwitterClient.sharedTwitterClient
        twitterClient?.login(success: {
            self.performSegue(withIdentifier: "goTweetsView", sender: nil)
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        
        
    }
    
    // List of global variables
    let reachability = Reachability()!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupReachability()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(noti:Notification)  {
        let reachability = noti.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via Wifi")
            } else {
                print("reachable via Cellular")
            }
        } else {
            print("Network not reachable")
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
