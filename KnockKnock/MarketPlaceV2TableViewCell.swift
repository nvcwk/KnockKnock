//
//  MarketPlaceV2TableViewCell.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 16/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import HCSStarRatingView

class MarketPlaceV2TableViewCell: PFTableViewCell {

    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_price: UILabel!
    @IBOutlet weak var image_background: PFImageView!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var stars: HCSStarRatingView!
    
    //MarketPlaceV2TableViewCell.postImageView.contentMode = UIViewContentMode.ScaleAspectFill
    
    override func awakeFromNib() {
        image_background.clipsToBounds = true
        image_background.contentMode = UIViewContentMode.ScaleAspectFill;

        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.image_background.frame = CGRectMake(0, 0, 66, 66)
        //self.image_background.clipsToBounds = true
        
        
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = UITableViewCellSelectionStyle.None

        // Configure the view for the selected state
    }


}
