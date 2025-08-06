//
//  RVCalendarView.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import UIKit

class RVCalendarView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewBaseBackground: UIView?
    @IBOutlet weak var calendarView: CollectionViewCalendar?
    @IBOutlet weak var labelCurrentMonth: UILabel?
    @IBOutlet weak var labelPreviousMonth: UILabel?
    @IBOutlet weak var labelNextMonth: UILabel?
    @IBOutlet weak var buttonPreviousMonth: UIButton?
    @IBOutlet weak var buttonNextMonth: UIButton?
    @IBOutlet weak var segmentButtonWeekMonth: UISegmentedControl!
    @IBOutlet weak var rvCalendarViewHeightConstraint: NSLayoutConstraint?

    enum CalendarViewAs {
        case WeekType
        case MonthType
    }
    var viewCalendarAs : CalendarViewAs = .MonthType
    
    private var selectedDate = Date()
    private var totalDays = [String]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    private func loadFromNib() {
        Bundle.main.loadNibNamed("RVCalendarView", owner: self, options: nil)
        guard let contentView = contentView else {
            fatalError("contentView not connected")
        }
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        commonSetup()
    }
    
    func commonSetup() {
        //calendarView?.calendarViewType = .monthView
        calendarView?.setupCollectionView(viewType: .monthView)
        calendarView?.calendarDelegate = self
        viewBaseBackground?.clipsToBounds = true
        viewBaseBackground?.layer.borderWidth = 1.0
        viewBaseBackground?.layer.borderColor = UIColor.gray.cgColor
        viewBaseBackground?.layer.cornerRadius = 20.0
        setupCalendarHeaders() 
    }
    
    func setupCalendarHeaders() {
        let monthLabelText = CalendarHelper().monthYearString(date: selectedDate)
        let previousMonth = CalendarHelper.shared.getPreviousMonth(from: selectedDate)
        let previousMonthText = CalendarHelper().monthName(from: previousMonth)
        let nextMonth = CalendarHelper.shared.getNextMonth(from: selectedDate)
        let nextMonthText = CalendarHelper().monthName(from: nextMonth)
        
        labelCurrentMonth?.text = monthLabelText
        if viewCalendarAs == .WeekType {
            labelPreviousMonth?.text = "Prev"
            labelNextMonth?.text = "Next"
        } else {
            labelPreviousMonth?.text = previousMonthText
            labelNextMonth?.text = nextMonthText
        }
    }
    
    @IBAction func buttonPreviousMonth(_ sender: Any) {
        if viewCalendarAs == .WeekType {
            calendarView?.goToPreviousWeek()
        } else {
            calendarView?.goToPreviousMonth()
        }
    }
    
    @IBAction func buttonNextMonth(_ sender: Any) {
        if viewCalendarAs == .WeekType {
            calendarView?.goToNextWeek()
        } else {
            calendarView?.goToNextMonth()
        }
    }
    
    func setDateSelectorColor(colorName: UIColor) {
        calendarView?.setDateSelectionColor(colorName: colorName)
        
    }
}

extension RVCalendarView {
    @IBAction func buttonSegmentChanged(_ sender: UISegmentedControl) {
        //Week View
        if sender.selectedSegmentIndex == 0 {
            self.rvCalendarViewHeightConstraint?.constant = 220
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                self.calendarView?.setupCollectionView(viewType: .weekView)
                self.layoutIfNeeded()
            }
            viewCalendarAs = .WeekType
        } else {
            //Month View
            self.rvCalendarViewHeightConstraint?.constant = 300
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                self.calendarView?.setupCollectionView(viewType: .monthView)
                self.layoutIfNeeded()
            }
            viewCalendarAs = .MonthType
        }
        setupCalendarHeaders()
    }
    
    func calendarViewTypeChanged(isWeekView: Bool) {
        //Week View
        if isWeekView {
            self.rvCalendarViewHeightConstraint?.constant = 180
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                self.calendarView?.setupCollectionView(viewType: .weekView)
                self.layoutIfNeeded()
            }
            viewCalendarAs = .WeekType
        } else {
            //Month View
            self.rvCalendarViewHeightConstraint?.constant = 300
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                self.calendarView?.setupCollectionView(viewType: .monthView)
                self.layoutIfNeeded()
            }
            viewCalendarAs = .MonthType
        }
        setupCalendarHeaders()
    }
}

extension RVCalendarView: CalendarCollectionDelegate {
    
    func currentMonth(nameText: String) {
        labelCurrentMonth?.text = nameText
    }
    
    func nextMonth(nameText: String) {
        labelNextMonth?.text = nameText
    }
    
    func previousMonth(nameText: String) {
        labelPreviousMonth?.text = nameText
    }
    
    func dateSelected(dateString: String) {
        print(dateString)
    }
    
}
