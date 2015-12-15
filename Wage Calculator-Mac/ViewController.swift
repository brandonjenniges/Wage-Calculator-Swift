//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, TimerProtocol {
    
    @IBOutlet weak var moneyLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    
    let timer = Timer()
    let moneyCalculator = MoneyCalculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer.delegate = self
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: - Timer Protocol
    
    func timerDidTick(elapsedSeconds: Int) {
        timeLabel.stringValue = timer.getTimeDisplay()
        moneyLabel.stringValue = moneyCalculator.getMoneyDisplay(timer.elapsedSeconds)
    }
    
    func timerDidReset() {
        timeLabel.stringValue = timer.getTimeDisplay()
        moneyLabel.stringValue = moneyCalculator.getMoneyDisplay(timer.elapsedSeconds)
    }
    
    // MARK: - Buttons
    
    @IBAction func play(sender: AnyObject) {
        timer.startTimer()
    }
    
    @IBAction func pause(sender: AnyObject) {
        timer.pauseTimer()
    }
    
    @IBAction func clear(sender: AnyObject) {
        timer.restartTimer()
    }

}

