import UIKit
import GMStepper
import Parse
import autoAutoLayout

class ItiDaysSelectorViewController: UIViewController {
    
    @IBOutlet weak var stepper_days: GMStepper!
    
    var itineraryObj = PFObject(className:"Itinerary")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue .identifier == "toActivitiesView") {
            let controller = segue.destinationViewController as! ItiActivitiesViewController
            controller.days = Int(stepper_days.value)
            controller.itineraryObj = itineraryObj
        }
        
    }
    
}
