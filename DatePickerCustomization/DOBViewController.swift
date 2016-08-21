//
//  DOBViewController.swift
//  DatePickerCustomization
//
//  Created by Justine Kay on 8/18/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import UIKit

extension NSDate {
    static func dateFromNow(years: Int) -> NSDate {
        let currentCalendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let components: NSDateComponents = NSDateComponents()
        components.year = years
        let dateFromNow: NSDate = currentCalendar.dateByAddingComponents(components, toDate: now, options: NSCalendarOptions(rawValue: 0))!
        return dateFromNow
    }
}

extension UITextField {
    func inputFieldStyle () {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(white: 1.0, alpha: 0.4).CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
}

private enum DatePickerProperties: String {
    case TextColor = "textColor"
    case HighlightsToday = "highlightsToday"
}

class DOBViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var ageRequirementLabel: UILabel!
    @IBOutlet weak var nextButton: NextButton!
    @IBOutlet weak var calendarImageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarImageViewLeadingConstraint: NSLayoutConstraint!
    
    private let kAgeMin = -100
    private let kAgeMax = -18
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.inputFieldStyle()
        setUpDatePicker()
        configureLayoutForIPhone4()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nextButton.enabled = false
    }
    
    // MARK: - UI
    private func configureLayoutForIPhone4() {
        if DeviceManager.isIPhone4 {
            calendarImageViewLeadingConstraint.constant = 160
            calendarImageViewTrailingConstraint.constant = 160 
        }
    }
    
    // MARK: - UIDatePicker
    
    private func setUpDatePicker() {
        datePicker.datePickerMode = .Date
        
        datePicker.minimumDate = NSDate.dateFromNow(kAgeMin)
        datePicker.maximumDate = NSDate.dateFromNow(kAgeMax)
        
        datePicker.setValue(UIColor.whiteColor(), forKey: DatePickerProperties.TextColor.rawValue)
        datePicker.setValue(false, forKey: DatePickerProperties.HighlightsToday.rawValue)
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender: AnyObject) {
        nextButton.enabled = true
        ageRequirementLabel.hidden = true
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        
        textField.text = dateFormatter.stringFromDate(sender.date)
        textField.inputView = datePicker
    }
}

struct DeviceManager {
    static let deviceHeight = UIWindow(frame: UIScreen.mainScreen().bounds).bounds.height
    static var isIPhone4: Bool { return deviceHeight <= 480 }
}
