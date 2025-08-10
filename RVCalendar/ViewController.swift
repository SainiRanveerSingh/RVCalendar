//
//  ViewController.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import UIKit

class ViewController: UIViewController {
    //Main Calendar View Outlet
    @IBOutlet weak var rvCalendar: RVCalendar!
    //Calendar View Height Constraint Outlet To Manage Height On The View
    @IBOutlet weak var rvCalendarHeightConstraint: NSLayoutConstraint!
    //Dictionary To Add Events On The Dates Of Calendar With Color Dots As Per Your Color Code For An Event (Can Show Max 5 Events Per Date With 5 Different Color)
    var dictDateColorsForEventDots = [String: [UIColor]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Date Format Must Be In The Below Format To Add The Event On The Calendar For Dates
        ///"dd/MM/yyyy"
        dictDateColorsForEventDots = ["10/08/2025":[UIColor.red, UIColor.blue, UIColor.lightGray, UIColor.green],
                                      "11/08/2025":[UIColor.red, UIColor.blue, UIColor.lightGray, UIColor.green],
                                      "12/08/2025":[UIColor.lightGray, UIColor.green, UIColor.brown],
                                      "13/08/2025":[UIColor.blue, UIColor.magenta],
                                      "14/08/2025":[UIColor.red],
                                      "17/08/2025":[UIColor.red, UIColor.blue]]
        rvCalendar.addEventsOn(datesWithColors: dictDateColorsForEventDots)
        //Assign Delegate To Self To Get Delegate Call Backs For Height And Selected Date Value
        rvCalendar.rvCalendarDelegate = self
    }
}

//MARK: - Calendar Delegate Methods -
extension ViewController:  RVCalendarDelegate {
    // Method To Get The Selected Date
    func selectedDate(stringValue: String) {
        print("Date Selected From Week View: \(stringValue)")
    }
    
    // Method To Update The Height When The User Switches Between Week And Month View Of Calendar
    func updateHeightTo(newHeight: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.rvCalendarHeightConstraint.constant = newHeight
        }
    }
}
    
