//
//  ComposeTweetViewController.swift
//  ZippyBird
//
//  Created by Vader1359 on 7/4/17.
//  Copyright © 2017 Vader1359. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    
    // List of Outlets
    @IBOutlet weak var tweetTf: UITextField!
    
    // List of Actions
    @IBAction func onCompose(_ sender: UIBarButtonItem) {
        twitterClient?.postStatus(status: tweetTf.text!, success: {
            print("Posted nicely")
        }, failure: { (error) in
            print(error.localizedDescription)
        })
        
        let tweetVC = storyboard!.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        self.navigationController?.present(tweetVC, animated: true, completion: nil)
    }
    
    // List of global variables
    let twitterClient = TwitterClient.sharedTwitterClient
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
