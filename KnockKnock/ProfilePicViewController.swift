//
//  ProfilePicViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 10/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse
import autoAutoLayout
import RSKImageCropper

class ProfilePicViewController: UIViewController {
    
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var btn_upload: UIButton!
    
    let imagePicker = UIImagePickerController()
    var popover: UIPopoverController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        self.img_profile.layer.cornerRadius = self.img_profile.frame.size.width/2
        self.img_profile.clipsToBounds = true
        
        imagePicker.delegate = self
    }
    
    
    @IBAction func actionProfile(sender: AnyObject) {
        KnockKnockImageUtils.imagePicker(self, picker: self.imagePicker)
    }
    
    @IBAction func actionUpload(sender: UIButton) {
        ParseUtils.updateProfileImage(img_profile.image!, controller: self)
    }
    
    
}

extension ProfilePicViewController: RSKImageCropViewControllerDelegate  {
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        img_profile.image = croppedImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ProfilePicViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let cropView = RSKImageCropViewController(image: image)
        cropView.cropMode = RSKImageCropMode.Circle
        cropView.delegate = self
        presentViewController(cropView, animated: false, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
