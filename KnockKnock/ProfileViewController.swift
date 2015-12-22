//
//  ProfileViewController.swift
//  KnockKnock
//
//  Created by Koh Siu Wei Brenda on 21/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var changePhoto : UIButton!

    @IBOutlet weak var hostTours: UIButton!
    @IBOutlet weak var joinedTours: UIButton!
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_contactNo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var current_User = PFUser.currentUser();
        
        
    }

    
    
    
    @IBAction func onClick_editprofile(sender: AnyObject) {
        
        if(editProfile.titleLabel?.text != "Save"){
            enableEditing()
            editProfile.titleLabel?.text = "Save"
        } else {
            disableEditing()
            editProfile.titleLabel?.text = "Edit Profile"
        }

    }

    
    
    func enableEditing(){
        tf_email.enabled == true
        tf_birthday.enabled == true
        tf_contactNo.enabled == true
    }
    
    
    func disableEditing(){
        tf_email.enabled == false
        tf_birthday.enabled == false
        tf_contactNo.enabled == false
    }
}