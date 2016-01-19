//
//  ProfileAvatar.swift
//  KnockKnock
//
//  Created by Koh Siu Wei Brenda on 18/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileAvatar: PFImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.width / 2.0
        
        self.layer.cornerRadius = radius
        self.backgroundColor = nil
    }
}