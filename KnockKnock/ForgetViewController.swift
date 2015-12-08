import UIKit
import SwiftValidator
import Parse

class ForgetViewController: UIViewController, ValidationDelegate {

    @IBOutlet weak var tb_email: UITextField!
    @IBOutlet weak var lb_email: UILabel!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validator.registerField(tb_email, errorLabel: lb_email, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        
        let emailIcon = UIImageView(image: UIImage(named: "username"))
        emailIcon.frame = CGRect(x: 60, y: 15, width: 25, height: 25)
        
        tb_email.leftView = emailIcon
        tb_email.leftViewMode = UITextFieldViewMode.Always
    }
    

    @IBAction func actionReset(sender: UIButton) {
        validator.validate(self)
    }
    
    func validationSuccessful() {
        PFUser.requestPasswordResetForEmailInBackground(tb_email.text!)
        
        KnockKnockUtils.okAlert(self, title: "Reset Password", message: "Please check your email",
            handle: { (action:UIAlertAction!) in
                self.performSegueWithIdentifier("toLogin", sender: self)})
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
