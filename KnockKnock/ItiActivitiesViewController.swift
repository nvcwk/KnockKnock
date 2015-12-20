import UIKit
import Parse
import SwiftSpinner

class ItiActivitiesViewController: UITableViewController {
    
    var itineraryObj = PFObject(className: "Itinerary")
    var activities = [Activity]()
    var days = 1
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as! ActivityTableViewCell
        cell.lb_day.text = "Day " + String(indexPath.row + 1)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue .identifier == "toActivityView") {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                
                if let index = indexPath?.row {
                    let controller = segue.destinationViewController as! ItiActivityViewController
                    controller.day = index + 1
                    
                    controller.activity = activities[index]
                }
            }
        }
    }
    
    @IBAction func backActivities(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        for _ in 1...days {
            activities.append(Activity())
        }
        
        //self.tableView.editing = true
    }
    
    @IBAction func actionSave(sender: AnyObject) {
        var cont = true
        
        for a in activities {
            if(!a.isCompleted) {
                cont = false
            }
        }
        
        if(cont) {
            SwiftSpinner.show("Saving...")
            
            itineraryObj.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if (success) {
                    var savingActivities = [PFObject]()
                    
                    for a in self.activities {
                        let activity = PFObject(className: "Activity")
                        
                        activity["title"] = a.title
                        activity["description"] = a.description
                        activity["meetingTime"] = a.meetingTime
                        activity["day"] = a.day
                        
                        if (a.address.isEmpty) {
                            activity["address"] = ""
                        } else {
                            activity["address"] = a.address
                        }
                        
                        activity["cordinate"] = PFGeoPoint(latitude: a.cor!.latitude, longitude: a.cor!.longitude)
                        activity["itineraryId"] = self.itineraryObj
                        
                        savingActivities.append(activity)
                    }
                    
                    PFObject.saveAllInBackground(savingActivities, block: { (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            SwiftSpinner.hide()
                            
                            
                        }
                    })
                    
                } else {
                    KnockKnockUtils.okAlert(self, title: "Error!", message: "Try Again!", handle: nil)
                }
            }
        } else {
            KnockKnockUtils.okAlert(self, title: "Error!", message: "Please fill in all details!", handle: nil)
        }
        
    }
    
    
    //    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    ////        let movedObject = self.data[sourceIndexPath.row]
    ////        data.removeAtIndex(sourceIndexPath.row)
    ////        data.insert(movedObject, atIndex: destinationIndexPath.row)
    //
    //        self.tableView.reloadData()
    //    }
    //
    //    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    //        return .None
    //    }
    //
    //    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        return false
    //    }
}
