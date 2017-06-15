//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import Foundation

protocol TimerProtocol {
    func timerDidTick(_ elapsedSeconds: Int)
    func timerDidReset()
}

class Timer: NSObject {
    
    var delegate: TimerProtocol?
    var timer = Foundation.Timer()
    
    let tickInterval: TimeInterval = 1.0
    var elapsedSeconds = 0
    
    let formatter = NumberFormatter()
    
    override init() {
        super.init()
        formatter.minimumIntegerDigits = 2
    }
    
    func startTimer() {
        self.timer = Foundation.Timer.scheduledTimer(timeInterval: tickInterval,
            target: self,
            selector: #selector(Timer.onTick),
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
    
    @objc func onTick() {
        elapsedSeconds += 1
        
        if let delegate = delegate {
            delegate.timerDidTick(elapsedSeconds)
        }
    }
    
    func getTimeDisplay() -> String {
        let time = (hour: elapsedSeconds / 3600, minute: (elapsedSeconds % 3600) / 60, second: (elapsedSeconds % 3600) % 60)
        
        let displayString = "\(formatter.string(from: NSNumber(value: time.hour))!):\(formatter.string(from: NSNumber(value: time.minute))!):\(formatter.string(from: NSNumber(value: time.second))!)"
        return displayString
    }
}
