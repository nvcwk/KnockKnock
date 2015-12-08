import UIKit
import Parse
import SwiftSpinner

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (PFUser.currentUser() == nil) {
            toLogin()
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func actionLogout(sender: UIButton) {
        SwiftSpinner.show("Logging out....")
        
        PFUser.logOutInBackgroundWithBlock( { (error: NSError?) -> Void in
            SwiftSpinner.hide()
            self.toLogin()
        })
    }
    
    func toLogin() {
        let viewController:UIViewController = UIStoryboard(name: "Credential", bundle: nil).instantiateInitialViewController()!
        self.presentViewController(viewController, animated: true, completion: nil)
    }

}
