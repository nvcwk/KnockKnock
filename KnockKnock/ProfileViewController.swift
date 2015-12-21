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
    
    
    @IBAction func profileEdit(sender: AnyObject) {
        enableEditing()
        
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