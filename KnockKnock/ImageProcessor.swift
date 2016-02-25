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

@objc protocol ImageProcessorDelegate {
    func getFinalImage(image: UIImage)
}

public enum ImageProcessorCropMode {
    case Square
    case Circle
}

class ImageProcessor: NSObject {
    var controller = UIViewController()
    var cropMode = ImageProcessorCropMode.Square //Default Square
    
    weak var delegate: ImageProcessorDelegate?
    
    override init() {
        super.init()
    }
    
    init(controller: UIViewController, mode: ImageProcessorCropMode) {
        super.init()
        
        self.controller = controller
        self.cropMode = mode
    }
}

extension ImageProcessor {
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

extension ImageProcessor: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let cropView = RSKImageCropViewController(image: image)
        
        if(cropMode == ImageProcessorCropMode.Circle) {
            cropView.cropMode = RSKImageCropMode.Circle
        } else if (cropMode == ImageProcessorCropMode.Square) {
            cropView.cropMode = RSKImageCropMode.Square
        }
        
        cropView.delegate = self
        controller.presentViewController(cropView, animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ImageProcessor: RSKImageCropViewControllerDelegate  {
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        delegate?.getFinalImage(UIImage(data: croppedImage.lowQualityJPEGNSData)!)
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

