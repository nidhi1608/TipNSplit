//
//  ViewController.swift
//  tips
//
//  Created by nidhi on 9/8/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var splitStepper: UIStepper!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var tipPerPersonLabel: UILabel!
    @IBOutlet weak var tipHeader: UILabel!
    @IBOutlet weak var totalHeader: UILabel!
    @IBOutlet weak var billContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipAmountLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        billField.delegate = self
        var defaults = NSUserDefaults.standardUserDefaults()
        var defaultTipIndex = defaults.integerForKey("default_tip")
        if defaultTipIndex == 0 {
            setSliderDefaults()
        } else {
            tipSlider.value = Float(defaultTipIndex)
            tipLabel.text = "\(defaultTipIndex)%"
        }
        billContainer.layer.cornerRadius = 8
        billContainer.layer.shadowOffset = CGSizeZero
        billContainer.layer.shadowRadius = 1
        billContainer.layer.shadowColor = UIColor.blackColor().CGColor
        billContainer.layer.shadowOpacity = 1
        UIView.setAnimationsEnabled(false)
        billField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTipIndex = defaults.integerForKey("default_tip")
        if defaultTipIndex == 0 {
            setSliderDefaults()
        } else {
            tipSlider.value = Float(defaultTipIndex)
            tipLabel.text = "\(defaultTipIndex)%"
        }
        // Load previous session data
        if let sessionDate = defaults.objectForKey("session_date") as? NSDate {
            if NSDate().timeIntervalSinceDate(sessionDate) < 10 * 60 {
                let billAmount = defaults.stringForKey("bill_amount")
                let tipPercentage = defaults.floatForKey("tip_percentage")
                let split = defaults.doubleForKey("split")
                billField.text = billAmount
                if split > 0 {
                    splitStepper.value = split
                }
                tipSlider.value = tipPercentage
                if tipPercentage == 0 {
                    setSliderDefaults()
                }
            }
        }
        updateValues(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }


    @IBAction func onEditingChanged(sender: AnyObject) {
        updateValues(true)
    }
    
    func setResultsHidden(hidden: Bool, animated: Bool) {
        setViewHidden(billContainer, hidden: hidden, animated: animated)
    }
    
    func setViewHidden(view: UIView, hidden: Bool, animated: Bool) {
        if view.hidden == hidden {
            return
        }
        if !animated {
            view.hidden = hidden
            return
        }
        view.hidden = false
        let frame = view.frame
        let offsetFrame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, frame.size.height)
        view.frame = offsetFrame
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            view.alpha = hidden ? 0 : 1
            view.frame = hidden ? offsetFrame : frame
            }, completion: { (Bool) -> Void in
                view.frame = frame
                view.hidden = hidden
        })
    }
    
    func setSliderDefaults() {
        tipSlider.value = 15
        tipLabel.text = "15%"
    }
    
    func updateValues(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(billField.text as NSString, forKey: "bill_amount")
        defaults.setFloat(tipSlider.value, forKey: "tip_percentage")
        defaults.setDouble(splitStepper.value, forKey: "split")
        defaults.setValue(NSDate(), forKey: "session_date")
        defaults.synchronize()
        let billAmount = (billField.text as NSString).doubleValue
        let tipPercentage = Int(tipSlider.value)
        tipLabel.text = "\(tipPercentage)%"
        
        if (billAmount > 0) {
            self.setResultsHidden(false, animated: animated)
            var tip = (billAmount * Double(tipPercentage)) / 100
            var total = billAmount + tip
            
            tipAmountLabel.text = "$\(tip)"
            totalLabel.text = "$\(total)"
            
            tipAmountLabel.text = String(format: "$%.2f", tip)
            totalLabel.text = String(format: "$%.2f", total)
            
            var split = Int(splitStepper.value)
            var amountPerPerson = total / Double(split)
            splitLabel.text = "\(split)"
            tipPerPersonLabel.text = String(format: "$%.2f", amountPerPerson)
        } else {
            self.setResultsHidden(true, animated: animated)
        }

    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) -> Void {
        textField.becomeFirstResponder()
    }
}

