//
//  ViewController.swift
//  tips
//
//  Created by nidhi on 9/8/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var splitStepper: UIStepper!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var tipPerPersonLabel: UILabel!
    @IBOutlet weak var splitHeader: UILabel!
    @IBOutlet weak var tipHeader: UILabel!
    @IBOutlet weak var totalHeader: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipAmountLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        var defaults = NSUserDefaults.standardUserDefaults()
        var defaultTipIndex = defaults.integerForKey("default_tip")
        tipSlider.value = Float(defaultTipIndex)
        tipLabel.text = "\(defaultTipIndex)%"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTipIndex = defaults.integerForKey("default_tip")
        tipSlider.value = Float(defaultTipIndex)
        tipLabel.text = "\(defaultTipIndex)%"
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
            }
        }
        billField.becomeFirstResponder()
        updateValues(animated)
    }


    @IBAction func onEditingChanged(sender: AnyObject) {
        updateValues(true)
    }
    
    func setResultsHidden(hidden: Bool, animated: Bool) {
        setViewHidden(tipAmountLabel, hidden: hidden, animated: animated)
        setViewHidden(totalLabel, hidden: hidden, animated: animated)
        setViewHidden(tipHeader, hidden: hidden, animated: animated)
        setViewHidden(totalHeader, hidden: hidden, animated: animated)
        setViewHidden(tipPerPersonLabel, hidden: hidden, animated: animated)
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
        let modifiedFrame = CGRectMake(frame.origin.x, frame.origin.y + 100, frame.size.width, frame.size.height)
        view.frame = hidden ? frame : modifiedFrame
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            view.alpha = hidden ? 0 : 1
            view.frame = hidden ? modifiedFrame : frame
            }, completion: { (Bool) -> Void in
                view.frame = frame
                view.hidden = hidden
        })
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
            tipPerPersonLabel.text = String(format: "$%.2f per person", amountPerPerson)
            tipPerPersonLabel.hidden = split == 1
        } else {
            self.setResultsHidden(true, animated: animated)
        }

    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

