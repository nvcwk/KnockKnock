//
//  ProfilePicViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 10/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse

class ProfilePicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var btn_upload: UIButton!
    
    var picker = UIImagePickerController()
    var popover: UIPopoverController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker, animated: true, completion: nil)
        } else {
            openGallery()
        }
    }
    
    func openGallery() {
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(picker, animated: true, completion: nil)
        } else {
            popover = UIPopoverController(contentViewController: picker)
            
            popover!.presentPopoverFromRect(btn_upload.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        img_profile.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionChange(sender: UIButton) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { UIAlertAction in }
        
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            popover = UIPopoverController(contentViewController: alert)
            
            popover!.presentPopoverFromRect(btn_upload.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    
    @IBAction func actionUpload(sender: UIButton) {
        ParseUtils.updateProfileImage(KnockKnockUtils.RBResizeImage(img_profile.image!, targetSize: CGSize(width: 300, height: 300)), controller: self)
    }
    

}
