//
//  ActivityTableViewCell.swift
//  KnockKnock
//
//  Created by Don Teo on 27/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

class MarketActivityTableViewCell: PFTableViewCell {
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var activityDesc: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}