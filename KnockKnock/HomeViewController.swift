import UIKit
import Parse
import SwiftSpinner

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseUtils.checkLogin(self)
    }

    @IBAction func actionLogout(sender: UIButton) {
       ParseUtils.logout(self)
        
    }
    

}
