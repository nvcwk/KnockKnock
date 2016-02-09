//
//  VerifyTourGuideViewController.swift
//  KnockKnock
//
//  Created by Ngo Kee Kai on 2/2/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner
import ParseFacebookUtilsV4
import TextFieldEffects
import autoAutoLayout
import GMStepper

class VerifyTourGuideViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tv_background: UITextView!
    @IBOutlet weak var tv_address: UITextView!
    @IBOutlet weak var tf_language: UITextField!
    @IBOutlet weak var tf_years: UITextField!
    
    var backgroundInput = false
    var addressInput = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        //Set up the text box for background
        tv_background.delegate = self
        
        tv_background.text = "Share with us your reasons why you want to be tour guide (Minimum 50 characters)"
        tv_background.textColor = UIColor.lightGrayColor()
        
        //Set up the text box for address
        tv_address.delegate = self
        
        tv_address.text = "Please provide us with your address"
        tv_address.textColor = UIColor.lightGrayColor()
        
        
    }

    @IBAction func tappedSubmitButton(sender: AnyObject) {
        
        let background = tv_background.text
        let address = tv_address.text
        let language = tf_language.text
        let years = tf_years.text
        
        if (background.characters.count < 50 || backgroundInput == false){
            let alertTitle = "Tell us more about yourself!"
            let message = String("Please enter a minimum of 50 characters")
            let okText = "Okay"
            
            let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okayButtton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okayButtton)
            
            presentViewController(alert, animated: true, completion: nil)
        } else if(language!.isEmpty){
            let alertTitle = "Please key in your language proficiency!"
            let message = String("Let us know more about you so we can help you find the right match!")
            let okText = "Okay"
            
            let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okayButtton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okayButtton)
            
            presentViewController(alert, animated: true, completion: nil)
        } else if (addressInput == false){
            
            let alertTitle = "Please key in your address!"
            let message = String("Let us know more about you")
            let okText = "Okay"
            
            let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okayButtton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okayButtton)
            
            presentViewController(alert, animated: true, completion: nil)
        
        }
        
        //validate the number of years

    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if tv_background.textColor == UIColor.lightGrayColor() {
            tv_background.text = nil
            tv_background.textColor = UIColor.blackColor()
            
            backgroundInput = true
        }
        
        if tv_address.textColor == UIColor.lightGrayColor() {
            tv_address.text = nil
            tv_address.textColor = UIColor.blackColor()
            
            addressInput = true
        }

    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if tv_background.text.isEmpty {
            tv_background.text = "Share with us your reasons why you want to be tour guide (Minimum 50 characters)"
            tv_background.textColor = UIColor.lightGrayColor()
            
            backgroundInput = false
        }
        
        if tv_address.text.isEmpty{
            tv_address.text = "Please provide us with your address"
            tv_address.textColor = UIColor.lightGrayColor()
            
            addressInput = false
        }
    }

}
