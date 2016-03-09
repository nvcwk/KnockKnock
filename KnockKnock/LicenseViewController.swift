//
//  LicenseViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 9/3/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import TextFieldEffects
import SwiftSpinner
import SwiftValidator
import autoAutoLayout

class LicenseViewController: UIViewController {

    var imgMgmt = ImageProcessor()
    
    @IBOutlet weak var img_license : PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        loadProfilePic()
        
        imgMgmt = ImageProcessor(controller: self, mode: ImageProcessorCropMode.Square)
        imgMgmt.delegate = self
        
    }
    
    func loadProfilePic() {
        let currentUser = PFUser.currentUser()!;
        
        if (currentUser["license"] != nil) {
            img_license.file = currentUser["license"] as! PFFile
            img_license.loadInBackground()
        }
    }

    @IBAction func actionSelectPic(sender: UITapGestureRecognizer) {
        // KnockKnockImageUtils.imagePicker(self, picker: self.imagePicker)
        
        print("jac")
        imgMgmt.displayPickerOptions()
    }
}


extension LicenseViewController: ImageProcessorDelegate {
    func getFinalImage(image: UIImage) {
        SwiftSpinner.show("Updating...")
        
        img_license.image = image
        
        let currentUser = PFUser.currentUser()!
        
        currentUser["license"] = PFFile(data: image.uncompressedPNGData)
        
        currentUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                SwiftSpinner.hide()
                
                self.loadProfilePic()
                
                KnockKnockUtils.okAlert(self, title: "Message!", message: "Updated New License Pic!", handle: nil)
                
            } else {
                KnockKnockUtils.okAlert(self, title: "Error!", message: "Try Again!", handle: nil)
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
}