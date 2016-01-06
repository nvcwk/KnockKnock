import UIKit
import GMStepper
import Parse

class ItiDaysSelectorViewController: UIViewController {
    
    @IBOutlet weak var stepper_days: GMStepper!
    
    var itineraryObj = PFObject(className:"Itinerary")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue .identifier == "toActivitiesView") {
            let controller = segue.destinationViewController as! ItiActivitiesViewController
            controller.days = Int(stepper_days.value)
            controller.itineraryObj = itineraryObj
        }
    }

}
