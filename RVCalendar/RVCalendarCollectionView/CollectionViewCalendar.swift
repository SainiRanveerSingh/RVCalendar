//
//  CollectionViewCalendar.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import UIKit

protocol CalendarCollectionDelegate {
    func currentMonth(nameText: String)
    func nextMonth(nameText: String)
    func previousMonth(nameText: String)
    func dateSelected(dateString: String)
}

class CollectionViewCalendar:  UICollectionView {
    enum CalendarViewType {
        case MonthView
        case WeekView
    }
    var calendarViewType: CalendarViewType = .MonthView
    
    //------- Calendar Month View -------
    private var selectedDate = Date()
    private var totalDays = [String]()
    var datesInMonth: [Date?] = []
    //------- Calendar Month View -------
    
    //------- Calendar Week View -------
    var selectedStartDate: Date = CalendarHelper().startOfWeek(from: Date())
    var weekDates: [Date] = []
    //------- Calendar Week View -------
    
    var calendarDelegate: CalendarCollectionDelegate?
    
    var dateSelectionColor = UIColor.white
    var cellSelectedToHighlight = -1
    
    var nextMonthName: String {
        let nextDate = CalendarHelper.shared.getNextMonth(from: selectedDate)
        return CalendarHelper.shared.monthName(from: nextDate)
    }
    
    var previousMonthName: String {
        let previousDate = CalendarHelper.shared.getPreviousMonth(from: selectedDate)
        return CalendarHelper.shared.monthName(from: previousDate)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCollectionView() {
        self.delegate = self
        self.dataSource = self
        //Cell registration
        let nib = UINib.init(nibName: "RVCalendarCollectionViewCell", bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: "RVCalendarCollectionViewCell")
        if calendarViewType == .WeekView {
            setupWeekView()
        } else {
            setupMonthView()
        }
        setupCollectionViewLayout()
    }
    
    func setDateSelectionColor(colorName: UIColor) {
        dateSelectionColor = colorName
    }
    
    //------ Calendar As Week View ------
    func setupWeekView() {
        weekDates.removeAll()
        for i in 0..<7 {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: selectedStartDate) {
                weekDates.append(date)
            }
        }
        
        self.reloadData()
    }
    
    //------ Calendar As Month View ------
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0 // space between columns (horizontal spacing)
        layout.minimumLineSpacing = 2       // 🔽 space between rows (vertical spacing)

        let totalWidth = self.bounds.width
        let cellWidth = totalWidth / 7
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)

        self.collectionViewLayout = layout
    }
    
    func setupMonthView() {
        totalDays.removeAll()
        datesInMonth.removeAll()
        cellSelectedToHighlight = -1
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDay = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDay)
        
        var count = 1
        while count <= 42 {
            if count <= startingSpaces || count - startingSpaces > daysInMonth {
                totalDays.append("")
                datesInMonth.append(nil) // blank cell
            } else {
                //totalDays.append("\(count - startingSpaces)")
                let day = count - startingSpaces
                totalDays.append("\(day)")
                
                if let validDate = CalendarHelper().calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                    datesInMonth.append(validDate) // actual Date
                } else {
                    datesInMonth.append(nil)
                }
            }
            count += 1
        }
        
        let monthLabelText = CalendarHelper().monthYearString(date: selectedDate)
        let previousMonth = CalendarHelper.shared.getPreviousMonth(from: selectedDate)
        let previousMonthText = CalendarHelper().monthName(from: previousMonth)
        let nextMonth = CalendarHelper.shared.getNextMonth(from: selectedDate)
        let nextMonthText = CalendarHelper().monthName(from: nextMonth)
        
        calendarDelegate?.previousMonth(nameText: previousMonthText)
        calendarDelegate?.currentMonth(nameText: monthLabelText)
        calendarDelegate?.nextMonth(nameText: nextMonthText)
        
        self.reloadData()
    }
    
    func calculateCalendarHeight(for date: Date) -> CGFloat {
        let weeks = CalendarHelper.shared.numberOfWeeksInMonth(for: date)
        let rowHeight: CGFloat = 40 // Or whatever your cell height is
        let totalHeight = CGFloat(weeks) * rowHeight
        return totalHeight
    }
    
    func goToPreviousMonth() {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setupMonthView()
    }
    
    func goToNextMonth() {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setupMonthView()
    }
    
    func goToNextWeek() {
        guard let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: selectedStartDate) else { return }
        selectedStartDate = nextWeek
        self.setupWeekView()
    }

    func goToPreviousWeek() {
        guard let previousWeek = Calendar.current.date(byAdding: .day, value: -7, to: selectedStartDate) else { return }
        selectedStartDate = previousWeek
        self.setupWeekView()
    }
    
}

// MARK: - UICollectionViewDataSource
extension CollectionViewCalendar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if calendarViewType == .WeekView {
            return weekDates.count
        } else {
            return totalDays.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "RVCalendarCollectionViewCell", for: indexPath) as! RVCalendarCollectionViewCell
        if calendarViewType == .WeekView {
            let date = weekDates[indexPath.item]
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            cell.labelDate.text = formatter.string(from: date)
        } else {
            cell.configure(with: totalDays[indexPath.item], index: indexPath.item)
            if cellSelectedToHighlight != -1 {
                cell.viewDateLabelSelection.backgroundColor = dateSelectionColor
            } else {
                cell.viewDateLabelSelection.backgroundColor = .white
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath.item)
        if let cell = collectionView.cellForItem(at: indexPath) as? RVCalendarCollectionViewCell {
            if cell.labelDate.text != "" {
                cellSelectedToHighlight = indexPath.item
                
                cell.viewDateLabelSelection.clipsToBounds = true
                cell.viewDateLabelSelection.layer.cornerRadius = cell.viewDateLabelSelection.frame.height / 2.0
                cell.viewDateLabelSelection.backgroundColor = dateSelectionColor
                let selectedDateValue = getDateForSelectedCell(atIndex: indexPath.item)
                //print("Selected Date: \(selectedDateValue)")
                calendarDelegate?.dateSelected(dateString: selectedDateValue)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        if let cell = collectionView.cellForItem(at: indexPath) as? RVCalendarCollectionViewCell {
            cellSelectedToHighlight = -1
            cell.labelDate.textColor = .black
            cell.viewDateLabelSelection.backgroundColor = .white
        }
    }
    
    func getDateForSelectedCell(atIndex: Int) -> String {
        let day = Int(totalDays[atIndex])!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        
        var dateComponents = DateComponents()
        dateComponents.year = components.year
        dateComponents.month = components.month
        dateComponents.day = day
        
        if let fullDate = calendar.date(from: dateComponents) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            //print("Selected Date: \(formatter.string(from: fullDate))")
            return formatter.string(from: fullDate)
        }
        
        return ""
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewCalendar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if calendarViewType == .WeekView {
            let width = (collectionView.frame.width - 2) / 7
            return CGSize(width: width, height: collectionView.frame.height)
        } else {
            let width = (collectionView.frame.width - 2) / 7
            let height = (collectionView.frame.height - 2) / 6
            return CGSize(width: width, height: height)
        }
    }
}
