//
//  CalendarHelper.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import Foundation
class CalendarHelper {
    
    static let shared = CalendarHelper()
    
    let calendar = Calendar.current

    func monthYearString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }

    func daysInMonth(date: Date) -> Int {
        calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }

    func firstOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? Date()
    }

    func weekDay(date: Date) -> Int {
        calendar.component(.weekday, from: date) - 1
    }

    func plusMonth(date: Date) -> Date {
        calendar.date(byAdding: .month, value: 1, to: date) ?? Date()
    }

    func minusMonth(date: Date) -> Date {
        calendar.date(byAdding: .month, value: -1, to: date) ?? Date()
    }
    
    func monthName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter.string(from: date)
    }
    
    func getPreviousMonth(from date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func getNextMonth(from date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }

}
