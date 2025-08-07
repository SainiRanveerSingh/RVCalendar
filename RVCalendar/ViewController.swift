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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rvCalendar.rvCalendarDelegate = self
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
    
