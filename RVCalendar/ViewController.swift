//
//  ViewController.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rvCalendarView: RVCalendarView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        rvCalendarView?.setDateSelectorColor(colorName: UIColor.green)
    }

    

}

