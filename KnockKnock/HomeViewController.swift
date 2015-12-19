import UIKit
import Parse
import SwiftSpinner
import ParseUI
import GoogleMaps

class HomeViewController: UIViewController {

    @IBOutlet weak var lb_temp: UILabel!
    @IBOutlet weak var image_profile: PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(ParseUtils.checkLogin(self)) {
            let user = ParseUtils.currentUser()
        
            lb_temp.text = String(user["lName"]!)
            
            image_profile.file = user["profilePic"] as! PFFile
            
            image_profile.loadInBackground()
            
        }
    }

    @IBAction func actionLogout(sender: UIButton) {
        ParseUtils.logout(self)
    }
}
