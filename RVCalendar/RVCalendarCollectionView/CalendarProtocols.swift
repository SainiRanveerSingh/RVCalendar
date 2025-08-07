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
}

//MARK: - Protocol Methods For Calendar As Week View
protocol CalendarWeekViewDelegate {
    func dateSelected(dateString: String)
}


protocol RVCalendarDelegate {
    func updateHeightTo(newHeight: CGFloat)
    func selectedDate(stringValue: String)
}
