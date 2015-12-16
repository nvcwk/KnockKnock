//
//  DetailedMarketplaceViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 16/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class DetailedMarketplaceViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var summaryField: UITextField!
    @IBOutlet weak var tourPic: UIImageView!
    
    var header: String! = ""
    var price: String! = ""
    var host: PFObject!
    var summary: String! = ""
    var picFile: PFFile!
    var currentObject : PFObject?
    var guide : PFUser?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerLabel.text = header
        self.priceLabel.text = String(price)
        
        // to include below two label once itenerary builder is up, currently no userid associated, will cause to crash
        //self.hostLabel.text = host["username"] as! String
       // self.contactLabel.text = guide["contact"] as! String
        self.summaryField.text = summary
        picFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                self.tourPic.image = UIImage(data:imageData!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    @IBAction func bookButtonTapped(sender: AnyObject) {
        
        
        let bookAlert = UIAlertController(title: "Book?", message: "Confirmed?", preferredStyle: UIAlertControllerStyle.Alert)
        
        bookAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.currentObject!["participant"] = PFUser.currentUser()
            
            let myAlert =
            UIAlertController(title:"Booking!!", message: "Please Wait...", preferredStyle: UIAlertControllerStyle.Alert);
            
            self.currentObject!.saveInBackgroundWithBlock {
                (success : Bool?, error: NSError?) -> Void in
                if (success != nil) {
                    let myAlert =
                    UIAlertController(title:"Done!!", message: "", preferredStyle: UIAlertControllerStyle.Alert);
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                    
                    myAlert.addAction(okAction);
                    
                    self.presentViewController(myAlert, animated:true, completion:nil);
                } else {
                    NSLog("%@", error!)
                }
            }
        }))
        
        bookAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        
        presentViewController(bookAlert, animated: true, completion: nil)
    }
    
    

}
