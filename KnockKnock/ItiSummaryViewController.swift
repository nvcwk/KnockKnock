//
//  ItiSummaryViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 18/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import DZNPhotoPickerController

class ItiSummaryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let imagePicker = UIImagePickerController()
    var popover: UIPopoverController? = nil
    
    @IBOutlet weak var img_Tour: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionTapImage(sender: UITapGestureRecognizer) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.cropSize = CGSizeMake(420, 300);
        
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
            
            popover!.presentPopoverFromRect(img_Tour.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            openGallery()
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            popover = UIPopoverController(contentViewController: imagePicker)
            
            popover!.presentPopoverFromRect(img_Tour.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        img_Tour.image = info[UIImagePickerControllerEditedImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backSummary(segue:UIStoryboardSegue) {
        
    }

}
