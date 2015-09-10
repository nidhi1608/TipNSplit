//
//  SettingsViewController.swift
//  tips
//
//  Created by nidhi on 9/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Read the default tip from NSUserDefaults storage
        var defaults = NSUserDefaults.standardUserDefaults()
        var defaultTipIndex = defaults.integerForKey("default_tip")
        if defaultTipIndex == 0 {
            tipSlider.value = 15
            tipLabel.text = "15%"
        } else {
            tipSlider.value = Float(defaultTipIndex)
            tipLabel.text = "\(defaultTipIndex)%"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onEditingChanged(sender: AnyObject) {
        var tipPercentage = Int(tipSlider.value)
        tipLabel.text = "\(tipPercentage)%"
        
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tipPercentage, forKey: "default_tip")
        defaults.setFloat(Float(tipPercentage), forKey: "tip_percentage")
        defaults.synchronize()
    }
}
