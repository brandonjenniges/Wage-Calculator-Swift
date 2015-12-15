//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TimerProtocol, BackgroundManagerProtocol {

    
    @IBOutlet weak var moneyView: UIView!
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    let timer = Timer()
    let moneyCalculator = MoneyCalculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer.delegate = self
        BackgroundManager.delegate = self
        setupMoneyViewGradient()
        moneyLabel.text = moneyCalculator.getMoneyDisplay(0)
        
        print(MoneyCalculator.getSavedWage())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMoneyViewGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = moneyView.bounds
        gradient.colors = [UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.0).CGColor, UIColor(red: 0/255.0, green: 160/255.0, blue: 233/255.0, alpha: 0.05).CGColor]
        moneyView.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func displayWagePrompt(active: Bool) {
        var inputTextField: UITextField?
        
        let alertController = UIAlertController(title: "Wage Calculator", message: "Enter a wage or hourly rate that will be used to calculate how much money you are making.", preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if let newWage = inputTextField!.text, doubleValue = Double(newWage) {
                MoneyCalculator.saveWage(doubleValue)
                self.moneyCalculator.updateWage()
                if active {
                    self.timer.startTimer()
                }
            }
        }))
        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = self.moneyCalculator.formatStringToCurrency("\(MoneyCalculator.getSavedWage())")
            textField.keyboardType = .DecimalPad
            inputTextField = textField
        })
        presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - Timer Protocol
    
    func timerDidTick(elapsedSeconds: Int) {
        timeLabel.text = timer.getTimeDisplay()
        moneyLabel.text = moneyCalculator.getMoneyDisplay(timer.elapsedSeconds)
    }
    
    func timerDidReset() {
        timeLabel.text = timer.getTimeDisplay()
        moneyLabel.text = moneyCalculator.getMoneyDisplay(timer.elapsedSeconds)
    }
    
    // MARK: - Background Manager Protocol
    
    func managerDidRequestStop() {
        timer.pauseTimer()
    }
    
    func managerDidReceiveBackgroundDuration(elapsedSeconds: Int) {
        timer.elapsedSeconds += elapsedSeconds
        timer.startTimer()
    }

    // MARK: - Buttons
    
    @IBAction func play(sender: AnyObject) {
        if MoneyCalculator.getSavedWage() > 0 {
            timer.startTimer()
        } else {
            displayWagePrompt(true)
        }
    }
    
    @IBAction func pause(sender: AnyObject) {
        timer.pauseTimer()
    }
    
    @IBAction func clear(sender: AnyObject) {
        timer.restartTimer()
    }
    
    @IBAction func openSettings(sender: AnyObject) {
        displayWagePrompt(false)
    }
}

