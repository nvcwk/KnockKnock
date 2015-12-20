import UIKit
import GMStepper

class ItiDaysViewController: UIViewController {
    
    @IBOutlet weak var stepper_days: GMStepper!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let controller = segue.destinationViewController as! ItiActivitiesViewController
        //controller.days = Int(stepper_days.value)
    }

}
