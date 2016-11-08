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
        gradient.colors = [UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.0).cgColor, UIColor(red: 0/255.0, green: 160/255.0, blue: 233/255.0, alpha: 0.05).cgColor]
        moneyView.layer.insertSublayer(gradient, at: 0)
    }
    
    func displayWagePrompt(_ active: Bool) {
        var inputTextField: UITextField?
        
        let alertController = UIAlertController(title: "Wage Calculator", message: "Enter a wage or hourly rate that will be used to calculate how much money you are making.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            if let newWage = inputTextField!.text, let doubleValue = Double(newWage) {
                MoneyCalculator.saveWage(doubleValue)
                self.moneyCalculator.updateWage()
                if active {
                    self.timer.startTimer()
                }
            }
        }))
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = self.moneyCalculator.formatStringToCurrency("\(MoneyCalculator.getSavedWage())")
            textField.keyboardType = .decimalPad
            inputTextField = textField
        })
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Timer Protocol
    
    func timerDidTick(_ elapsedSeconds: Int) {
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
    
    func managerDidReceiveBackgroundDuration(_ elapsedSeconds: Int) {
        timer.elapsedSeconds += elapsedSeconds
        timer.startTimer()
    }

    // MARK: - Buttons
    
    @IBAction func play(_ sender: AnyObject) {
        if MoneyCalculator.getSavedWage() > 0 {
            timer.startTimer()
        } else {
            displayWagePrompt(true)
        }
    }
    
    @IBAction func pause(_ sender: AnyObject) {
        timer.pauseTimer()
    }
    
    @IBAction func clear(_ sender: AnyObject) {
        timer.restartTimer()
    }
    
    @IBAction func openSettings(_ sender: AnyObject) {
        displayWagePrompt(false)
    }
}

