//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import Foundation

class MoneyCalculator: NSObject {

    var wage: Double = 0.0
    let formatter = NSNumberFormatter()
    
    static let wageKey = "savedWage"
    static let userDefaults = NSUserDefaults.standardUserDefaults()

    
    override init() {
        
        self.wage = MoneyCalculator.getSavedWage()
        
        self.formatter.numberStyle = .CurrencyStyle
        self.formatter.minimumIntegerDigits = 1
        self.formatter.minimumFractionDigits = 2
        self.formatter.maximumFractionDigits = 2
        
        super.init()
    }
    
    func updateWage() {
        self.wage = MoneyCalculator.getSavedWage()
    }
    
    func getMoneyDisplay(seconds: Int) -> String {
        let factor: Double = Double(seconds) / 3600
        return "\(formatter.stringFromNumber(wage * factor)!)"
    }
    
    static func getSavedWage() -> Double {
        return userDefaults.doubleForKey(wageKey)
    }
    
    static func saveWage(wage: Double) {
        return userDefaults.setDouble(wage, forKey: wageKey)
    }
    
    func formatStringToCurrency(string: String) -> String? {
        if let doubleValue = Double(string) {
            return self.formatter.stringFromNumber(doubleValue)
        }
        return nil
    }
}
