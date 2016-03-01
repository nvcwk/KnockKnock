//
//  MessageTableViewCell.swift
//  KnockKnock
//
//  Created by Don Teo on 29/2/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import JSQMessagesViewController


class MessageTableViewCell: UITableViewCell {
        
      
    @IBOutlet var userImage: PFImageView!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    
    @IBOutlet weak var counterLabel: UILabel!
    
        func bindData(message: PFObject) {
            userImage.layer.cornerRadius = userImage.frame.size.width / 2
            userImage.layer.masksToBounds = true
            
            let lastUser = message.objectForKey("LastUser") as? PFUser
            userImage.file = lastUser?["profilePic"] as? PFFile
            userImage.loadInBackground(nil)
            
            descriptionLabel.text = message.objectForKey("MsgDescription") as? String
            lastMessageLabel.text = message.objectForKey("LastMessage") as? String
            
            let seconds = NSDate().timeIntervalSinceDate(message.objectForKey("Update") as! NSDate)
            timeElapsedLabel.text = KnockKnockUtils.timeElapsed(seconds)
            let dateText = JSQMessagesTimestampFormatter.sharedFormatter().relativeDateForDate(message.objectForKey("Update") as? NSDate)
            if dateText == "Today" {
                timeElapsedLabel.text = JSQMessagesTimestampFormatter.sharedFormatter().timeForDate(message.objectForKey("Update") as? NSDate)
            } else {
                timeElapsedLabel.text = dateText
            }
            
            let counter = message.objectForKey("Counter") as! Int
            counterLabel.text = (counter == 0) ? "" : "\(counter) new"
        }
        
    
}
