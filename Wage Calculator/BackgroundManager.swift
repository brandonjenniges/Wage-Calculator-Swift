//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import UIKit

protocol BackgroundManagerProtocol {
    func managerDidRequestStop()
    func managerDidReceiveBackgroundDuration(elapsedSeconds: Int)
}

class BackgroundManager: NSObject {
    
    static var delegate: BackgroundManagerProtocol?
    
    static let backgroundKey = "time"
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    static func setBackgroundTime() {
        let now = NSDate()
        userDefaults.setObject(now, forKey: backgroundKey)
        
        /** Debug printing **/
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .FullStyle
        print("backgrounded at: \(dateFormatter.stringFromDate(now))")
        
    }
    
    static func getBackgroundTime() -> NSDate {
        if let backgroundTime = userDefaults.objectForKey(backgroundKey) as? NSDate {
            return backgroundTime
        }
        return NSDate()
    }
    
    static func appDurationInBackground() -> Int {
        let elapsedTime = NSDate().timeIntervalSinceDate(getBackgroundTime())
        print("Elapsed time in seconds: \(elapsedTime)")
        return Int(elapsedTime) //TODO: - Round up or down here??
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
