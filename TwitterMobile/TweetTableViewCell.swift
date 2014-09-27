//
//  TwittTableViewCell.swift
//  TwitterMobile
//
//  Created by Scott Liu on 9/27/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var reTweetLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
       override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
