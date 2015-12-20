import UIKit
import DZNPhotoPickerController
import SwiftValidator
import SwiftSpinner
import Parse

class ItiSummaryViewController: UIViewController {
    
    @IBOutlet weak var tf_title: UITextField!
    @IBOutlet weak var tv_summary: UITextView!
    @IBOutlet weak var img_tour: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let validator = Validator()
    var validationStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tv_summary.delegate = self
        imagePicker.delegate = self
        
        validator.registerField(tf_title, rules: [RequiredRule(message: "Fill in title!")])
    }
    
    @IBAction func actionTapImage(sender: UITapGestureRecognizer) {
        KnockKnockImageUtils.imagePicker(self, picker: self.imagePicker)
    }

    @IBAction func backSummary(segue:UIStoryboardSegue) { }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(identifier == "toSelectDaysView") {
            validator.validate(self)
        
            return validationStatus
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toSelectDaysView") {
            uploadDraft()
            SwiftSpinner.hide()
        }
    }
    
    private func uploadDraft() {
        SwiftSpinner.show("Creating Itinerary...", animated: true)
        
        let gameScore = PFObject(className:"Itinerary")
        gameScore["status"] = "d"
        gameScore["title"] = tf_title.text
        gameScore["summary"] = tv_summary.text
        gameScore["host"] = PFUser.currentUser()
        gameScore["image"] = PFFile(data: UIImagePNGRepresentation(img_tour.image!)!)!
        
        gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
            } else {
                 KnockKnockUtils.okAlert(self, title: "Error!", message: "Try Again!", handle: nil)
            }
        }
    }
}

extension ItiSummaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        img_tour.image = info[UIImagePickerControllerEditedImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ItiSummaryViewController: ValidationDelegate {
    func validationSuccessful() {
        if(validateOthers()) {
            validationStatus = true
        } else {
            validationStatus = false
        }
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        validationStatus = false
        KnockKnockUtils.okAlert(self, title: "Error!", message: (errors.values.first?.errorMessage)!, handle: nil)
    }
    
    func validateOthers() -> Bool {
        var isGood = true
        
        if(tv_summary.text.isEmpty) {
            isGood = false
            KnockKnockUtils.okAlert(self, title: "Error!", message: "Fill in summary!", handle: nil)
        }
        
        if(img_tour.image == nil) {
            isGood = false
            KnockKnockUtils.okAlert(self, title: "Error!", message: "Select an image!", handle: nil)
        }
        
        return isGood
    }
}

extension ItiSummaryViewController : UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let checkString = "\n"
        let crCount = countOccurrences(textView.text, forSubstring: checkString) + countOccurrences(text, forSubstring: checkString)
        
        if(crCount > 4) {
            return false
        }
        
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        
        return newLength <= 200
    }
    
    private func countOccurrences(toCheck: String, forSubstring: String) -> Int
    {
        var tokenArray = toCheck.componentsSeparatedByString(forSubstring)
        return tokenArray.count-1
    }
}
