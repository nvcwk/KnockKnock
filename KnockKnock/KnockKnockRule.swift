import Foundation
import SwiftValidator

public class KnockKnockRule : Rule {
    
    private var REGEX: String = "^(?=.*?[A-Z]).{8,}$"
    private var message : String
    
    public init(regex: String, message: String = "Invalid Regular Expression"){
        self.REGEX = regex
        self.message = message
    }
    
    public func validate(value: String) -> Bool {
        let match = try! NSRegularExpression(pattern: REGEX, options: [.CaseInsensitive])
        
        let range = NSMakeRange(0, value.characters.count)
        
        let matchRange = match.rangeOfFirstMatchInString(value, options: .ReportProgress, range: range)
        
        let valid = matchRange.location != NSNotFound
        
        return valid
    }
    
    public func errorMessage() -> String {
        return message
    }
}
