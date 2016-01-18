//
//  MyCustomTextField.swift
//  KnockKnock
//
//  Created by Koh Siu Wei Brenda on 18/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit

class MyCustomTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}