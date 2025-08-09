//
//  ViewController.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rvCalendar: RVCalendar!
    @IBOutlet weak var rvCalendarHeightConstraint: NSLayoutConstraint!
    var dictDateColorsForEventDots = [String: [UIColor]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Date Format Must Be
        ///"dd/MM/yyyy"
        dictDateColorsForEventDots = ["10/08/2025":[UIColor.red, UIColor.blue, UIColor.lightGray, UIColor.green],
                                      "11/08/2025":[UIColor.red, UIColor.blue, UIColor.lightGray, UIColor.green],
                                      "12/08/2025":[UIColor.lightGray, UIColor.green, UIColor.brown],
                                      "13/08/2025":[UIColor.blue, UIColor.magenta],
                                      "14/08/2025":[UIColor.red],
                                      "17/08/2025":[UIColor.red, UIColor.blue]]
        rvCalendar.rvCalendarDelegate = self
        rvCalendar.addEventsOn(datesWithColors: dictDateColorsForEventDots)
    }
}

extension ViewController:  RVCalendarDelegate {
    func selectedDate(stringValue: String) {
        print("Date Selected From Week View: \(stringValue)")
    }
    
    func updateHeightTo(newHeight: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.rvCalendarHeightConstraint.constant = newHeight
        }
    }
}
    
