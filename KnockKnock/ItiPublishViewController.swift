import UIKit
import GMStepper
import Parse
import SwiftDate
import SwiftSpinner

class ItiPublishViewController: UIViewController {
   
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var stepper_price: GMStepper!
    @IBOutlet weak var tf_startDate: UITextField!
    @IBOutlet weak var tf_endDate: UITextField!
    @IBOutlet weak var tf_id: UILabel!
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var selectedEndDate = 5.days.fromDate(NSDate())
    var selectedStartDate = 5.days.fromDate(NSDate())
    
    var itineraryObj = PFObject(className: "Itinerary")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.minimumDate = 5.days.fromDate(NSDate())
        startDatePicker.addTarget(self, action: Selector("updateStartDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_startDate.inputView = startDatePicker
        tf_startDate.text = KnockKnockUtils.dateToString(5.days.fromDate(NSDate()))
        
        endDatePicker.datePickerMode = UIDatePickerMode.Date
        endDatePicker.minimumDate = 5.days.fromDate(NSDate())
        endDatePicker.addTarget(self, action: Selector("updateEndDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_endDate.inputView = endDatePicker
        tf_endDate.text = KnockKnockUtils.dateToString(5.days.fromDate(NSDate()))

        lb_title.text = itineraryObj["title"] as! String
        tf_id.text = "Itinerary ID: #" + itineraryObj.objectId!
    }
    
    func updateStartDate(sender: UIDatePicker) {
        tf_startDate.text = KnockKnockUtils.dateToString(sender.date)
        itineraryObj["startDay_availability"] = sender.date
        
        endDatePicker.minimumDate = sender.date
        
        if(selectedEndDate < sender.date) {
            tf_endDate.text = ""
        }
    }
    
    func updateEndDate(sender: UIDatePicker) {
        tf_endDate.text = KnockKnockUtils.dateToString(sender.date)
        itineraryObj["lastDay_availability"] = sender.date
        selectedEndDate = sender.date
    }
    
    
    @IBAction func actionPublish(sender: UIBarButtonItem) {
        SwiftSpinner.show("Publishing...")
        
        itineraryObj["price"] = stepper_price.value
        itineraryObj["status"] = "p"
        
        itineraryObj.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            SwiftSpinner.hide()
            
            if (success) {
                
                KnockKnockUtils.okAlert(self, title: "Publish!", message: "Successful", handle: { (action:UIAlertAction!) in
                     self.dismissViewControllerAnimated(true, completion: nil)})
            } else {
                KnockKnockUtils.okAlert(self, title: "Error!", message: "Try Again!", handle: nil)
            }
        }
    }

}

