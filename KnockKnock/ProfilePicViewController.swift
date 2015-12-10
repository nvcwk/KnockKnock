//
//  ProfilePicViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 10/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import DZNPhotoPickerController

class ProfilePicViewController: UIViewController {
    
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var btn_upload: UIButton!
    
    var picker = DZNPhotoPickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

}
