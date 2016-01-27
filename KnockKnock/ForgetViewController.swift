import UIKit
import SwiftValidator
import Parse
import SwiftSpinner
import autoAutoLayout

class ForgetViewController: UIViewController, ValidationDelegate {

    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var lb_email: UILabel!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        validator.registerField(tf_email, errorLabel: lb_email, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
    }
    

    @IBAction func actionReset(sender: UIButton) {
        validator.validate(self)
    }
    
    func validationSuccessful() {
        SwiftSpinner.show("Loading...")
        
        PFUser.requestPasswordResetForEmailInBackground(tf_email.text!) { (success, error) -> Void in
            SwiftSpinner.hide()
            
            if (error == nil) {
                KnockKnockUtils.okAlert(self, title: "Reset Password", message: "Please check your email",
                    handle: { (action:UIAlertAction!) in
                        self.performSegueWithIdentifier("toLogin", sender: self)})
                
            } else {
                KnockKnockUtils.okAlert(self, title: "Error", message: "Invalid Email", handle: nil)
            }
        }
        
        
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage 
            error.errorLabel?.hidden = false
        }
    }
    
    

}
