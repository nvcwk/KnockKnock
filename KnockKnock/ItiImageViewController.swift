//
//  ItiImageViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 5/2/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import autoAutoLayout
import Parse

class ItiImageViewController: UIViewController {
    @IBOutlet weak var img_image1: UIImageView!
    @IBOutlet weak var img_image2: UIImageView!
    @IBOutlet weak var img_image3: UIImageView!
    @IBOutlet weak var img_image4: UIImageView!
    
    var itiObj = PFObject(className:"Itinerary")
    
    let imagePicker = UIImagePickerController()
    var selectedImage = 0
    
    var imagesArr = [NSData]()
    var placeHolder = NSData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        imagePicker.delegate = self
        
        
        placeHolder = UIImagePNGRepresentation(UIImage(named: "Image_Placeholder")!)!
        
        for _ in 1...4 {
            imagesArr.append(placeHolder)
        }
    }
    
    @IBAction func actionImage1(sender: UITapGestureRecognizer) {
        selectedImage = 1
        KnockKnockImageUtils.imagePicker(self, picker: self.imagePicker)
    }
    
    @IBAction func actionImage2(sender: UITapGestureRecognizer) {
        selectedImage = 2
        KnockKnockImageUtils.imagePicker(self, picker: self.imagePicker)
    }
    
    @IBAction func actionImage3(sender: UITapGestureRecognizer) {
        selectedImage = 3
        KnockKnockImageUtils.imagePicker(self, picker: self.imagePicker)
    }
    
    @IBAction func actionImage4(sender: UITapGestureRecognizer) {
        selectedImage = 4
        KnockKnockImageUtils.imagePicker(self, picker: self.imagePicker)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(identifier == "itiStep31") {
            var images = [PFObject]()
            
            for i in 0...3 {
                if (self.imagesArr[i] != placeHolder) {
                    var imgObj = PFObject(className: "Images")
                    imgObj["image"] = PFFile(data: self.imagesArr[i])
                    
                    images.append(imgObj)
                }
            }
            
            
            if(images.count < 1) {
                KnockKnockUtils.okAlert(self, title: "Message!", message: "Fill in at least one image!", handle: nil)
                
                return false
            } else {
                itiObj["image"] = PFFile(data: placeHolder) // to be removed
                itiObj["images"] = images
                
                return true
            }
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                if(segue .identifier == "itiStep31") {
                    let controller = segue.destinationViewController as! ItiDaysSelectorViewController
                    controller.itineraryObj = itiObj
                }
    }
    
    
}

extension ItiImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        var image = UIImage()
        var no = 0
        
        if(selectedImage == 1) {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
            img_image1.image = image
            no = 1
        } else if (selectedImage == 2) {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
            img_image2.image = image
            no = 2
        } else if (selectedImage == 3) {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
            img_image3.image = image
            no = 3
        } else if (selectedImage == 4) {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
            img_image4.image = image
            no = 4
        }
        
        editImageArr(image,no: no)
    }
    
    func editImageArr(image: UIImage, no: Int) {
        imagesArr[no - 1] = UIImagePNGRepresentation(image)!
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

