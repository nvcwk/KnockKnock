import UIKit
import CountryPicker

class Register2ViewController: UIViewController {
    
    @IBOutlet weak var tf_country: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_pass: UITextField!
    @IBOutlet weak var tf_cfmPass: UITextField!
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_contact: UITextField!
    
//    var selectedDate = NSDate()
//    
//    let countryPickerView = CountryPicker()
//    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        countryPickerView.delegate = self
//        countryPickerView.selectedLocale = NSLocale.currentLocale()
//        tf_country.inputView = countryPickerView
//        tf_country.text = countryPickerView.selectedCountryName
//        
//        datePicker.datePickerMode = UIDatePickerMode.Date
//        datePicker.maximumDate = NSDate()
//        datePicker.addTarget(self, action: Selector("updateBirthday:"),
//            forControlEvents:UIControlEvents.ValueChanged)
//        tf_birthday.inputView = datePicker
    }
//    
//    func updateBirthday(sender: UIDatePicker) {
//        tf_birthday.text = KnockKnockUtils.dateToString(sender.date)
//        selectedDate = sender.date
//    }
//    
//    func countryPicker(picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!) {
//        tf_country.text = name
//    }
    
    @IBAction func actionSignUp(sender: UIButton) {
               //ParseUtils.signUp(self, email: tf_email.text!, username: tf_username.text!, password: tf_pass.text!, country: tf_country.text!, contact: Int(tf_country.text!)!, birthday: selectedDate)
    }
}
