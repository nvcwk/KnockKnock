import UIKit
import CountryPicker
import PIDatePicker

class RegisterViewController: UIViewController, CountryPickerDelegate {
    
    @IBOutlet weak var tf_country: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_pass: UITextField!
    @IBOutlet weak var tf_cfmPass: UITextField!
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_contact: UITextField!
    
    let countryPickerView = CountryPicker()
    let datePickerView = PIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryPickerView.delegate = self
        countryPickerView.selectedLocale = NSLocale.currentLocale()
        tf_country.inputView = countryPickerView
        tf_country.text = countryPickerView.selectedCountryName
        
        
    }

    func countryPicker(picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!) {
        tf_country.text = name
    }
    
}
