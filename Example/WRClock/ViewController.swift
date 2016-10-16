//
//  ViewController.swift
//  WRClock
//
//  Created by Wojciech Rutkowski on 10/05/2016.
//  Copyright (c) 2016 Wojciech Rutkowski. All rights reserved.
//

import UIKit
import WRClock

class ViewController: UIViewController {
    
    @IBOutlet weak var clock: WRClock!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        clock.realTime = false
        clock.startDate = Date().addingTimeInterval(-6*3600)
        clock.clockRatio = -40.0
        clock.refreshTimeInterval = 0.1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func realTime(_ sender: AnyObject) {
        clock.realTime = true
        clock.staticTime = false
        clock.clockRatio = 1.0
        clock.refreshTimeInterval = 1.0
        clock.update()
    }
    
    @IBAction func fastReverseTime(_ sender: AnyObject) {
        clock.realTime = false
        clock.staticTime = false
        clock.clockRatio = -40.0
        clock.refreshTimeInterval = 0.1
        clock.update()
    }
    
    @IBAction func static12OClock(_ sender: AnyObject) {
        clock.realTime = false
        clock.staticTime = true
        clock.clockRatio = 1.0
        clock.refreshTimeInterval = 1.0
        clock.startDate = Calendar(identifier: .gregorian).date(from: DateComponents())
        clock.update()
    }
}

