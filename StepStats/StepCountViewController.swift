//
//  ViewController.swift
//  StepStats
//
//  Created by Mayank Kumar on 4/15/16.
//  Copyright © 2016 Mayank Kumar. All rights reserved.
//

import UIKit

class StepCountViewController: UIViewController {

    let healthManager = HealthManager()
    @IBOutlet var stepCountLabel: UILabel!
    @IBOutlet var welcomeDescription: UILabel!
    @IBOutlet var stepsin24h: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
    }

    override func viewDidAppear(animated: Bool) {
        fetchInformation()
    }

    func fetchInformation() {
        if !healthManager.checkAuth() {
            stepCountLabel.text = "-"
            welcomeDescription.text = "API Access Denied"
            stepsin24h.text = "Device not compatible."
        }
        else {
            welcomeDescription.text = "You've covered"
            stepsin24h.text = "steps in the last 24 hours"
            healthManager.fetchStepCount() { steps, success in
                dispatch_async(dispatch_get_main_queue()) {
                    if success {
                        self.stepCountLabel.text = String(Int(steps))
                    }
                }
            }
        }
    }

    func setBackgroundColor() {
        self.view.backgroundColor = UIColor.orangeColor()
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        let lightColor = UIColor.yellowColor().CGColor
        let darkColor = UIColor.redColor().CGColor
        gradient.colors = [lightColor, darkColor];
        gradient.locations = [0.25, 0.75]
        gradient.opacity = 0.4
        self.view.layer.addSublayer(gradient)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

