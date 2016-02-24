//
//  ImgMgmt.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 24/2/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import Foundation
import UIKit
import RSKImageCropper

@objc protocol ImgMgmtDelegate {
    func getFinalImage(image: UIImage)
}

public enum ImgMgmtCropMode {
    case Square
    case Circle
}

class ImgMgmt: NSObject {
    var controller = UIViewController()
    var cropMode = RSKImageCropMode.Square
    
    weak var delegate: ImgMgmtDelegate?
    
    override init() {
        super.init()
    }
    
    init(controller: UIViewController, mode: ImgMgmtCropMode) {
        super.init()
        
        self.controller = controller
        
        if(mode == ImgMgmtCropMode.Circle) {
            cropMode = RSKImageCropMode.Circle
        } else if (mode == ImgMgmtCropMode.Square) {
            cropMode = RSKImageCropMode.Square
        }
    }
    
    func displayPickerOptions() {
        let alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { UIAlertAction in
            self.openPicker(0)
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { UIAlertAction in
            self.openPicker(1)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { UIAlertAction in }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openPicker(choice: Int) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if(choice == 0) {
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                picker.sourceType = UIImagePickerControllerSourceType.Camera
                controller.presentViewController(picker, animated: true, completion: nil)
            } else {
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                controller.presentViewController(picker, animated: true, completion: nil)
            }
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            controller.presentViewController(picker, animated: true, completion: nil)
        }
    }
}

extension ImgMgmt: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let cropView = RSKImageCropViewController(image: image)
        cropView.cropMode = cropMode
        cropView.delegate = self
        controller.presentViewController(cropView, animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ImgMgmt: RSKImageCropViewControllerDelegate  {
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        delegate?.getFinalImage(UIImage(data: croppedImage.lowQualityJPEGNSData)!)
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

