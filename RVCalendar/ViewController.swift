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
    @IBOutlet weak var segmentButtonWeekMonth: UISegmentedControl!
    @IBOutlet weak var labelCalendarViewType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        rvCalendarView?.setDateSelectorColor(colorName: UIColor.green)
        segmentButtonWeekMonth.selectedSegmentIndex = 1
        labelCalendarViewType.text = "Calendar View"
    }

    @IBAction func buttonSegmentChanged(_ sender: UISegmentedControl) {
        //Week View
        if sender.selectedSegmentIndex == 0 {
            labelCalendarViewType.text = "List View"
            self.rvCalendarViewHeightConstraint?.constant = 220
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                //self.rvCalendarView?.calendarView?.setupCollectionView(viewType: .weekView)
                self.view.layoutIfNeeded()
            }
            //rvCalendarView?.viewCalendarAs = .WeekType
            rvCalendarView?.calendarViewTypeChanged(isWeekView: true)
        } else {
            //Month View
            labelCalendarViewType.text = "Calendar View"
            self.rvCalendarViewHeightConstraint?.constant = 432
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                //self.rvCalendarView?.calendarView?.setupCollectionView(viewType: .monthView)
                self.view.layoutIfNeeded()
            }
            //rvCalendarView?.viewCalendarAs = .MonthType
            rvCalendarView?.calendarViewTypeChanged(isWeekView: false)
        }
    }
    

}

