import UIKit
import Parse

class KnockKnockUtils {
    
    // Call storyboard and instantiate initial view
    static func storyBoardCall(controller: UIViewController, story: String, animated: Bool) {
        let viewController : UIViewController = UIStoryboard(name: story, bundle: nil).instantiateInitialViewController()!
        
        controller.presentViewController(viewController, animated: animated, completion: nil)
    }
    
    // Call storyboard and instantiate specific view
    static func storyBoardCall(controller: UIViewController, story: String, animated: Bool, view: String) {
        let viewController : UIViewController = UIStoryboard(name: story, bundle: nil).instantiateViewControllerWithIdentifier(view)
        
        controller.presentViewController(viewController, animated: animated, completion: nil)
    }
    
    // Call Alert with ok button
    static func okAlert(controller: UIViewController, title: String, message: String, handle: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .Default, handler: handle)
        
        alertController.addAction(OKAction)
        
        controller.presentViewController(alertController, animated: true, completion:nil)
    }
    
    // Convert date to string
    // Convert date to string in local time zone
    static func dateToString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        //formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss z"
        formatter.timeZone = NSTimeZone.localTimeZone()
        return formatter.stringFromDate(date)
    }
    
    // Convert date to string
    static func timeToString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateFormat = "dd MMM yyyy"
        formatter.timeZone = NSTimeZone(name: "UTC +8")
        return formatter.stringFromDate(date)
    }
    
    // Convert string to date
    static func StringToDate(stringDate: String) -> NSDate{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.timeZone = NSTimeZone(name: "GMT")
        return formatter.dateFromString(stringDate)!
    }
    
    
    //Before pushing to parse, the timezone will be in UTC +0000
    static func dateToParse(stringDate: String) -> NSDate{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss z"
        formatter.timeZone = NSTimeZone.localTimeZone()
        return formatter.dateFromString(stringDate)!
    }
    
    // Resize Image
    static func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func trimmText(text: String) -> String {
        let spaceSet = NSCharacterSet.whitespaceCharacterSet()
        let trimmed = text.stringByTrimmingCharactersInSet(spaceSet)
        
        return trimmed
    }
    
}