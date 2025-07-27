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
}

class CollectionViewCalendar:  UICollectionView {
    
    private var selectedDate = Date()
    private var totalDays = [String]()
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
        setupMonthView()
        setupCollectionViewLayout()
    }
    
    func setDateSelectionColor(colorName: UIColor) {
        dateSelectionColor = colorName
    }
    
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
        cellSelectedToHighlight = -1
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDay = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDay)
        
        var count = 1
        while count <= 42 {
            if count <= startingSpaces || count - startingSpaces > daysInMonth {
                totalDays.append("")
            } else {
                totalDays.append("\(count - startingSpaces)")
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
}

// MARK: - UICollectionViewDataSource
extension CollectionViewCalendar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "RVCalendarCollectionViewCell", for: indexPath) as! RVCalendarCollectionViewCell
        
        cell.configure(with: totalDays[indexPath.item], index: indexPath.item)
        if cellSelectedToHighlight != -1 {
            cell.viewDateLabelSelection.backgroundColor = dateSelectionColor
        } else {
            cell.viewDateLabelSelection.backgroundColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        if let cell = collectionView.cellForItem(at: indexPath) as? RVCalendarCollectionViewCell {
            if cell.labelDate.text != "" {
                cellSelectedToHighlight = indexPath.item
                
                cell.viewDateLabelSelection.clipsToBounds = true
                cell.viewDateLabelSelection.layer.cornerRadius = cell.viewDateLabelSelection.frame.height / 2.0
                cell.viewDateLabelSelection.backgroundColor = dateSelectionColor
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
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewCalendar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 2) / 7
        let height = (collectionView.frame.height - 2) / 6
        return CGSize(width: width, height: height)
    }
}
