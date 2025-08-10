//
//  CalendarProtocols.swift
//  RVCalendar
//
//  Created by RV on 07/08/25.
//

import Foundation
//MARK: - Protocol Methods For Calendar As Month View

protocol CalendarCollectionDelegate {
    func currentMonth(nameText: String)
    func nextMonth(nameText: String)
    func previousMonth(nameText: String)
    func dateSelected(dateString: String)
    func newCalendarMonth(date: Date)
    func newMonthCalendar(height: CGFloat)
}

//Making It Optional As Its Not Working Properly Need To Work More On This Part
extension CalendarCollectionDelegate {
    func newMonthCalendar(height: CGFloat) {
        
    }
}

//MARK: - Protocol Methods For Calendar As Week View
protocol CalendarWeekViewDelegate {
    func dateSelected(dateString: String)
    func weekViewMonthChangedTo(newDate: Date)
}

//MARK: - Protocol Methods For Calendar As Month View
protocol CalendarMonthViewDelegate {
    func monthViewSelected(dateString: String)
    func monthViewMonthChangedTo(newDate: Date)
    func monthViewNewMonthCalendar(height: CGFloat)
}

//Making It Optional As Its Not Working Properly Need To Work More On This Part
extension CalendarMonthViewDelegate {
    func monthViewNewMonthCalendar(height: CGFloat) {
        
    }
}


protocol RVCalendarDelegate {
    func updateHeightTo(newHeight: CGFloat)
    func selectedDate(stringValue: String)
}
