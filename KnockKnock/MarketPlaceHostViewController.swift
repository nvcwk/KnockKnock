//
//  MarketPlaceHostViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 9/3/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import autoAutoLayout

class MarketPlaceHostViewController: UIViewController {
    
    @IBOutlet weak var img_profile: ProfileAvatar!
    
    @IBOutlet weak var reviewTableContainer: UIView!
    
   // var reviewTableView: MarketplaceHostReviewViewController?
    var hostObj = PFUser()

    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var img_license: PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        var reviewTableView = MarketplaceHostReviewViewController()
        reviewTableView.hostObject = hostObj
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        self.img_profile.layer.cornerRadius = self.img_profile.frame.size.width/2
        self.img_profile.clipsToBounds = true
        
        let fName = hostObj["fName"] as! String
        let lName = hostObj["lName"] as! String
        
        lbl_name.text = fName + " " + lName
        
        if (hostObj["profilePic"] != nil) {
            img_profile.file = hostObj["profilePic"] as! PFFile
            img_profile.loadInBackground()
        }
        
        
        if(hostObj["license"] != nil) {
            if (hostObj["license"] != nil) {
                img_license.file = hostObj["license"] as! PFFile
                img_license.loadInBackground()
            }
        } else {
            img_license.hidden = true
        }
    }
}
