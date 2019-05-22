//
//  ViewController.swift
//  LMGaugeViewSwift
//
//  Created by LMinh on 05/22/2019.
//  Copyright (c) 2019 LMinh. All rights reserved.
//

import UIKit
import LMGaugeViewSwift

class ViewController: UIViewController, LMGaugeViewDelegate {

    var timeDelta: Double = 1.0/24
    var velocity: Double = 0
    var acceleration: Double = 5
    
    @IBOutlet weak var gaugeView: LMGaugeView!
    @IBOutlet weak var nightModeSwitch: UISwitch!
    @IBOutlet weak var aboutLabel: UILabel!
    
    // MARK: VIEW LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure gauge view
        let screenMinSize = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let ratio = Double(screenMinSize)/320
        gaugeView.divisionsRadius = 1.25 * ratio
        gaugeView.subDivisionsRadius = (1.25 - 0.5) * ratio
        gaugeView.ringThickness = 16 * ratio
        gaugeView.valueFont = UIFont(name: LMGaugeView.defaultFontName, size: CGFloat(140 * ratio))!
        gaugeView.unitOfMeasurementFont = UIFont(name: LMGaugeView.defaultFontName, size: CGFloat(16 * ratio))!
        gaugeView.minMaxValueFont = UIFont(name: LMGaugeView.defaultMinMaxValueFont, size: CGFloat(12 * ratio))!
        
        // Update gauge view
        gaugeView.minValue = 0
        gaugeView.maxValue = 120
        gaugeView.limitValue = 50
        
        // Create a timer to update value for gauge view
        Timer.scheduledTimer(timeInterval: timeDelta,
                             target: self,
                             selector: #selector(updateGaugeTimer),
                             userInfo: nil,
                             repeats: true)
    }

    // MARK: LMGAUGEVIEW DELEGATE
    
    func ringStokeColor(gaugeView: LMGaugeView, value: Double) -> UIColor {
        if value >= gaugeView.limitValue {
            return UIColor(red: 1, green: 59.0/255, blue: 48.0/255, alpha: 1)
        }
        if nightModeSwitch.isOn {
            return UIColor(red: 76.0/255, green: 217.0/255, blue: 100.0/255, alpha: 1)
        }
        return UIColor(red: 11.0/255, green: 150.0/255, blue: 246.0/255, alpha: 1)
    }
    
    // MARK: EVENTS

    @objc func updateGaugeTimer(timer: Timer) {
        // Calculate velocity
        velocity += timeDelta * acceleration
        if velocity > gaugeView.maxValue {
            velocity = gaugeView.maxValue
            acceleration = -5
        }
        if velocity < gaugeView.minValue {
            velocity = gaugeView.minValue
            acceleration = 5
        }
        
        // Set value for gauge view
        gaugeView.value = velocity
    }
    
    @IBAction func changedStyleSwitchValueChanged(_ sender: Any) {
        if !nightModeSwitch.isOn {
            UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
            view.backgroundColor = UIColor(white: 0.1, alpha: 1)
            aboutLabel.textColor = .white
            
            gaugeView.ringBackgroundColor = .black
            gaugeView.valueTextColor = .white
            gaugeView.unitOfMeasurementTextColor = UIColor(white: 0.7, alpha: 1)
            gaugeView.setNeedsDisplay()
        }
        else {
            UIApplication.shared.setStatusBarStyle(.default, animated: true)
            view.backgroundColor = .white
            aboutLabel.textColor = .black
            
            gaugeView.ringBackgroundColor = UIColor(white: 0.9, alpha: 1)
            gaugeView.valueTextColor = UIColor(white: 0.1, alpha: 1)
            gaugeView.unitOfMeasurementTextColor = UIColor(white: 0.3, alpha: 1)
            gaugeView.setNeedsDisplay()
        }
    }
}

