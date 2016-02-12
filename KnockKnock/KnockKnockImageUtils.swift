import UIKit

class KnockKnockImageUtils {
    
    static func imagePicker(controller: UIViewController, picker: UIImagePickerController) {
        //        picker.allowsEditing = true
        //        picker.cropSize = CGSizeMake(320, 320); // <- there is a bug
        
        let alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { UIAlertAction in
            KnockKnockImageUtils.cameraPicker(controller, picker: picker)
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { UIAlertAction in
            KnockKnockImageUtils.openGallery(controller, picker: picker)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { UIAlertAction in }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        controller.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    private static func cameraPicker(controller: UIViewController, picker: UIImagePickerController) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            controller.presentViewController(picker, animated: true, completion: nil)
        } else {
            KnockKnockImageUtils.openGallery(controller, picker: picker)
        }
    }
    
    private static func openGallery(controller: UIViewController, picker: UIImagePickerController) {
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        controller.presentViewController(picker, animated: true, completion: nil)
    }
    
    
}