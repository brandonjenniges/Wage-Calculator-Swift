//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import Foundation

protocol TimerProtocol {
    func timerDidTick(elapsedSeconds: Int)
    func timerDidReset()
}

class Timer: NSObject {
    
    var delegate: TimerProtocol?
    var timer = NSTimer()
    
    let tickInterval: NSTimeInterval = 1.0
    var elapsedSeconds = 0
    
    let formatter = NSNumberFormatter()
    
    override init() {
        super.init()
        formatter.minimumIntegerDigits = 2
    }
    
    func startTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(tickInterval,
            target: self,
            selector: "onTick",
            userInfo: nil,
            repeats: true)
    }
    
    func pauseTimer() {
        self.timer.invalidate()
    }
    
    func restartTimer() {
        self.timer.invalidate()
        elapsedSeconds = 0
        
        if let delegate = delegate {
            delegate.timerDidReset()
        }
    }
    
    func onTick() {
        elapsedSeconds++
        
        if let delegate = delegate {
            delegate.timerDidTick(elapsedSeconds)
        }
    }
    
    func getTimeDisplay() -> String {
        let time = (hour: elapsedSeconds / 3600, minute: (elapsedSeconds % 3600) / 60, second: (elapsedSeconds % 3600) % 60)
        
        let displayString = "\(formatter.stringFromNumber(time.hour)!):\(formatter.stringFromNumber(time.minute)!):\(formatter.stringFromNumber(time.second)!)"
        return displayString
    }
}
