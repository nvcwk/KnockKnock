import UIKit
import Parse
import SwiftSpinner

class ItiActivitiesViewController: UITableViewController {
    var itineraryObj = PFObject(className: "Itinerary")
    
    var activities = [PFObject]()
    var days = 1
    var completed = [Bool]()
    
    @IBAction func backActivities(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        completed = [Bool](count: days, repeatedValue: false)
        
        for _ in 1...days {
            let activityObj = PFObject(className: "Activity")
            activityObj["title"] = String()
            activityObj["description"] = String()
            
            activities.append(activityObj)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as! ActivityTableViewCell
        cell.lb_day.text = "Day " + String(indexPath.row + 1)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toActivityView") {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                
                if let index = indexPath?.row {
                    let controller = segue.destinationViewController as! ItiActivityViewController
                    controller.day = index + 1
                    controller.activityObj = activities[index]
                }
            }
        } else if (segue.identifier == "toPublishView") {
            let controller = segue.destinationViewController as! ItiPublishViewController
            
            controller.itineraryObj = itineraryObj
        }
    }
    
    func save(publish: Bool) {
        SwiftSpinner.show("Saving...")
        
        itineraryObj["activities"] = activities
        itineraryObj["duration"] = days
        
        self.itineraryObj.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                SwiftSpinner.hide()
                
                if(publish) {
                    self.performSegueWithIdentifier("toPublishView", sender: nil)
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            } else {
                KnockKnockUtils.okAlert(self, title: "Error!", message: "Try Again!", handle: nil)
            }
        }
    }
    
    @IBAction func actionSave(sender: AnyObject) {
        
        var canCon = true
        
        for con in completed {
            if(!con) {
                canCon = false
            }
        }
        
        if(canCon) {
            let alert:UIAlertController = UIAlertController(title: "Proceed to?", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let cameraAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { UIAlertAction in
                self.save(false)
            }
            
            let gallaryAction = UIAlertAction(title: "Save and Publish", style: UIAlertActionStyle.Default) { UIAlertAction in
                self.save(true)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { UIAlertAction in }
            
            alert.addAction(cameraAction)
            alert.addAction(gallaryAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            KnockKnockUtils.okAlert(self, title: "Error!", message: "Please fill in all details!", handle: nil)
        }
    }
}
