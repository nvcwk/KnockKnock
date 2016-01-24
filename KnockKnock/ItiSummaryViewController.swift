import UIKit
import SwiftValidator
import Parse
import autoAutoLayout

class ItiSummaryViewController: UIViewController {
    
    @IBOutlet weak var tf_title: UITextField!
    @IBOutlet weak var tv_summary: UITextView!
    @IBOutlet weak var img_tour: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let validator = Validator()
    var validationStatus = false
    
    var setImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        tv_summary.delegate = self
        imagePicker.delegate = self
        
        validator.registerField(tf_title, rules: [RequiredRule(message: "Fill in title!"), MinLengthRule(length: 5, message: "Title min 5 characters"), MaxLengthRule(length: 50, message: "Title max 50 characters")])
    }
    
    @IBAction func actionTapImage(sender: UITapGestureRecognizer) {
        KnockKnockImageUtils.imagePicker(self, picker: self.imagePicker)
    }
    
    @IBAction func backSummary(segue:UIStoryboardSegue) { }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(identifier == "toSelectDaysView") {
            tf_title.text = KnockKnockUtils.trimmText(tf_title.text!)
            tv_summary.text = KnockKnockUtils.trimmText(tv_summary.text)
            
            validator.validate(self)
            
            return validationStatus
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toSelectDaysView") {
            let itinerary = PFObject(className:"Itinerary")
            itinerary["status"] = "d"
            itinerary["title"] = tf_title.text
            itinerary["summary"] = tv_summary.text
            itinerary["host"] = PFUser.currentUser()
            itinerary["image"] = PFFile(data: UIImagePNGRepresentation(img_tour.image!)!)!
            
            let controller = segue.destinationViewController as! ItiDaysSelectorViewController
            controller.itineraryObj = itinerary
            
        }
    }
}

extension ItiSummaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        img_tour.image = info[UIImagePickerControllerEditedImage] as? UIImage
        setImage = true
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
        
        if(!setImage) {
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
