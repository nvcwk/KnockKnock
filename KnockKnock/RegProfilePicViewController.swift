//
//  RegProfilePicViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 10/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import DZNPhotoPickerController

class RegProfilePicViewController: UIViewController, UINavigationControllerDelegate, DZNPhotoPickerControllerDelegate {
    
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var btn_upload: UIButton!
    
    //var picker = DZNPhotoPickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        picker.delegate = self
//        picker.cropMode = DZNPhotoEditorViewControllerCropMode.Circular
//        picker.enablePhotoDownload = false
//        picker.allowsEditing = true;

        
        // Do any additional setup after loading the view.
    }
    
    func photoPickerController(picker: DZNPhotoPickerController!, didFinishPickingPhotoWithInfo userInfo: [NSObject : AnyObject]!) {
        
    }
    
 
    func photoPickerController(picker: DZNPhotoPickerController!, didFailedPickingPhotoWithError error: NSError!) {
        
    }
    
    func photoPickerControllerDidCancel(picker: DZNPhotoPickerController!) {
        
    }
    
    @IBAction func actionUploadImage(sender: AnyObject) {
        //presentViewController(picker, animated: true, completion: nil)
           }
    

    
}
