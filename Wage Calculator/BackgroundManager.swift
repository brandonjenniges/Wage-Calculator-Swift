//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import UIKit

protocol BackgroundManagerProtocol {
    func managerDidRequestStop()
    func managerDidReceiveBackgroundDuration(_ elapsedSeconds: Int)
}

class BackgroundManager: NSObject {
    
    static var delegate: BackgroundManagerProtocol?
    
    static let backgroundKey = "time"
    static let userDefaults = UserDefaults.standard
    
    static func setBackgroundTime() {
        let now = Date()
        userDefaults.set(now, forKey: backgroundKey)
        
        /** Debug printing **/
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full
        print("backgrounded at: \(dateFormatter.string(from: now))")
        
    }
    
    static func getBackgroundTime() -> Date {
        if let backgroundTime = userDefaults.object(forKey: backgroundKey) as? Date {
            return backgroundTime
        }
        return Date()
    }
    
    static func appDurationInBackground() -> Int {
        let elapsedTime = Date().timeIntervalSince(getBackgroundTime())
        print("Elapsed time in seconds: \(elapsedTime)")
        return Int(elapsedTime)
    }
    
    static func requestStop() {
        if let delegate = delegate {
            delegate.managerDidRequestStop()
        }
    }
    
    static func updateDelegate() {
        if let delegate = delegate {
            delegate.managerDidReceiveBackgroundDuration(appDurationInBackground())
        }
    }
    
}
