//
//  ReviewsTableCell.swift
//  KnockKnock
//
//  Created by Don Teo on 26/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import ParseUI
import HCSStarRatingView

class ReviewsTableCell: PFTableViewCell {

    @IBOutlet weak var reviwer: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var stars: HCSStarRatingView!
    @IBOutlet weak var date: UILabel!
   
    @IBOutlet weak var profile_image: PFImageView!

}
