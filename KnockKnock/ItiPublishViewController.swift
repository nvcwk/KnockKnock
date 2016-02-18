import UIKit
import GMStepper
import Parse
import SwiftDate
import SwiftSpinner
import autoAutoLayout

class ItiPublishViewController: UIViewController {
   
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_price: UITextField!
    @IBOutlet weak var tf_startDate: UITextField!
    @IBOutlet weak var tf_endDate: UITextField!
//    @IBOutlet weak var tf_id: UILabel!
    
    //    @IBOutlet weak var stepper_price: GMStepper!
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var selectedEndDate = 5.days.fromDate(NSDate())
    var selectedStartDate = 5.days.fromDate(NSDate())
    
    var itineraryObj = PFObject(className: "Itinerary")
    var publishObj = PFObject(className: "MarketPlace")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        lb_price.delegate = self
        
        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.minimumDate = 5.days.fromDate(NSDate())
        startDatePicker.addTarget(self, action: Selector("updateStartDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_startDate.inputView = startDatePicker
        tf_startDate.text = KnockKnockUtils.dateToStringDisplay(5.days.fromDate(NSDate()))
        
        endDatePicker.datePickerMode = UIDatePickerMode.Date
        endDatePicker.minimumDate = 5.days.fromDate(NSDate())
        endDatePicker.addTarget(self, action: Selector("updateEndDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_endDate.inputView = endDatePicker
        tf_endDate.text = KnockKnockUtils.dateToStringDisplay(5.days.fromDate(NSDate()))

        lb_title.text = itineraryObj["title"] as! String
        
        publishObj["startAvailability"] = NSDate()
        publishObj["lastAvailability"] = NSDate()
//        tf_id.text = "Itinerary ID: #" + itineraryObj.objectId!
    }
    
    func updateStartDate(sender: UIDatePicker) {
        tf_startDate.text = KnockKnockUtils.dateToStringDisplay(sender.date)
        publishObj["startAvailability"] = sender.date
        if(selectedEndDate < sender.date) {
            tf_endDate.text = KnockKnockUtils.dateToStringDisplay(sender.date)
            publishObj["lastAvailability"] = sender.date
        }
        endDatePicker.minimumDate = sender.date
    }
    
    func updateEndDate(sender: UIDatePicker) {
        tf_endDate.text = KnockKnockUtils.dateToStringDisplay(sender.date)
        publishObj["lastAvailability"] = sender.date
        selectedEndDate = sender.date
    }
    
    
    @IBAction func actionPublish(sender: UIBarButtonItem) {
        var price = Int(lb_price.text!)
        
        if (price == nil || price! == 0){
            KnockKnockUtils.okAlert(self, title: "Please Check Price", message: "Please enter valid price!", handle: nil)
        }else{

        
        SwiftSpinner.show("Publishing...")
        
        publishObj["price"] = Int(lb_price.text!)
        publishObj["itinerary"] = itineraryObj
        publishObj["host"] = PFUser.currentUser()!
        publishObj["isPublished"] = true
        publishObj["bookedDate"] = [NSDate]()
        
        publishObj.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            SwiftSpinner.hide()
            
            if (success) {
                
                KnockKnockUtils.okAlert(self, title: "Publish!", message: "Successful", handle: { (action:UIAlertAction!) in
                    NSNotificationCenter.defaultCenter().postNotificationName("loadPublish", object: nil)
                    
                     self.navigationController?.popToRootViewControllerAnimated(false)})
            } else {
                KnockKnockUtils.okAlert(self, title: "Error!", message: "Try Again!", handle: nil)
            }
        }
        }
    }

}

extension ItiPublishViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 3 // Bool
    }
}

