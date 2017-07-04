//
//  TweetCell.swift
//  ZippyBird
//
//  Created by Vader1359 on 7/3/17.
//  Copyright © 2017 Vader1359. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    // List of Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    // List of Actions
    
    // List of global variables
    
    var tweet: Tweet! {
        didSet {
            profileImg.setImageWith(tweet.userProfileImgURL!)
            usernameLabel.text = tweet.username
            tweetLabel.text = tweet.text
            timeStampLabel.text = "Waiting"
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
