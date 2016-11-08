//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import Foundation

class MoneyCalculator: NSObject {

    var wage: Double = 0.0
    let formatter = NumberFormatter()
    
    static let wageKey = "savedWage"
    static let userDefaults = UserDefaults.standard

    
    override init() {
        
        self.wage = MoneyCalculator.getSavedWage()
        
        self.formatter.numberStyle = .currency
        self.formatter.minimumIntegerDigits = 1
        self.formatter.minimumFractionDigits = 2
        self.formatter.maximumFractionDigits = 2
        
        super.init()
    }
    
    func updateWage() {
        self.wage = MoneyCalculator.getSavedWage()
    }
    
    func getMoneyDisplay(_ seconds: Int) -> String {
        let factor: Double = Double(seconds) / 3600
        return "\(formatter.string(from: NSNumber(value: wage * factor))!)"
    }
    
    static func getSavedWage() -> Double {
        return userDefaults.double(forKey: wageKey)
    }
    
    static func saveWage(_ wage: Double) {
        userDefaults.set(wage, forKey: wageKey)
        userDefaults.synchronize()
    }
    
    func formatStringToCurrency(_ string: String) -> String? {
        if let doubleValue = Double(string) {
            return self.formatter.string(from: NSNumber(value: doubleValue))
        }
        return nil
    }
}
