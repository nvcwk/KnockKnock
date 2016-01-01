//
//  ActivityDetailsTableViewCell.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 1/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit

class ActivityDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lb_day: UILabel!
    @IBOutlet weak var tv_details: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
