//
//  ItiTableViewCell.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 30/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import ParseUI

class ItiTableViewCell: PFTableViewCell {


    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_created: UILabel!
    @IBOutlet weak var image_background: PFImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
