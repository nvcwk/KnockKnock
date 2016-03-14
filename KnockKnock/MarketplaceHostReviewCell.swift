//
//  MarketplaceHostReviewCell.swift
//  KnockKnock
//
//  Created by Don Teo on 14/3/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import ParseUI
import HCSStarRatingView

class MarketplaceHostReviewCell: PFTableViewCell {

    @IBOutlet weak var stars: HCSStarRatingView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var reviwer: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var profile_image: PFImageView!
    @IBOutlet weak var role: UILabel!
    
}
