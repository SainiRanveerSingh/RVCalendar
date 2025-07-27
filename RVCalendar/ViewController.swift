//
//  ViewController.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rvCalendarView: RVCalendarView?
    @IBOutlet weak var rvCalendarViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        rvCalendarView?.setDateSelectorColor(colorName: UIColor.green)
    }

    @IBAction func buttonSegmentChanged(_ sender: UISegmentedControl) {
        //Week View
        if sender.selectedSegmentIndex == 0 {
            self.rvCalendarViewHeightConstraint?.constant = 180
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                //self.rvCalendarView?.calendarView?.setupCollectionView(viewType: .weekView)
                self.view.layoutIfNeeded()
            }
            
        } else {
            //Month View
            self.rvCalendarViewHeightConstraint?.constant = 432
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                //self.rvCalendarView?.calendarView?.setupCollectionView(viewType: .monthView)
                self.view.layoutIfNeeded()
            }
        }
    }
    

}

