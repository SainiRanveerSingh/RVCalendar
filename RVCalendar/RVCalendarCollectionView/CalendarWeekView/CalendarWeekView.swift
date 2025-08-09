//
//  CalendarWeekView.swift
//  RVCalendar
//
//  Created by RV on 27/07/25.
//

import UIKit

class CalendarWeekView: UIView {
    @IBOutlet weak var weekContentView: UIView!
    @IBOutlet weak var weekViewBaseBackground: UIView?
    @IBOutlet weak var calendarWeekView: CollectionViewCalendar?
    @IBOutlet weak var labelCurrentWeekMonth: UILabel?
    @IBOutlet weak var labelPreviousWeek: UILabel?
    @IBOutlet weak var labelNextWeek: UILabel?
    @IBOutlet weak var buttonPreviousWeek: UIButton?
    @IBOutlet weak var buttonNextWeek: UIButton?

    private var selectedStartDate: Date = CalendarHelper().startOfWeek(from: Date())
    //--
    var allWeeks: [[Date?]] = []
    var currentWeekIndex = 0
    var currentWeek: [Date?] {
        guard currentWeekIndex >= 0 && currentWeekIndex < allWeeks.count else { return [] }
        return allWeeks[currentWeekIndex]
    }
    var selectedMonthDate: Date = Date()
    //--
    private var weekDates: [Date?] = []
    private var cellSelectedToHighlight = -1
    var dateSelectionColor = UIColor.green
   
    private var selectedDate = Date()
    
    var weekViewCalendarDelegate: CalendarWeekViewDelegate?
    
    //To Setup Event Dots With Specific Colors
    var dictDateEventArrayColors = [String: [UIColor]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    private func loadFromNib() {
        Bundle.main.loadNibNamed("CalendarWeekView", owner: self, options: nil)
        guard let contentView = weekContentView else {
            fatalError("contentView not connected")
        }
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        setupCollectionView()
    }
    
    func setupCollectionView() {
        calendarWeekView?.delegate = self
        calendarWeekView?.dataSource = self
        //Cell registration
        let nib = UINib.init(nibName: "RVCalendarCollectionViewCell", bundle: nil)
        calendarWeekView?.register(nib, forCellWithReuseIdentifier: "RVCalendarCollectionViewCell")
        
        setupWeekView()
        setupCollectionViewLayout()
        setupCalendarHeaders()
    }
    
    func setupCalendarHeaders() {
        let monthLabelText = CalendarHelper().monthYearString(date: selectedMonthDate)
        labelCurrentWeekMonth?.text = monthLabelText
    }
    
    func setDateSelectionColor(colorName: UIColor) {
        dateSelectionColor = colorName
    }
    
    func setupWeekView() {
        allWeeks.removeAll()
        let calendar = Calendar.current

        // Get the first day of the month
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedStartDate)) else { return }

        // Number of days in the month
        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return }

        // Build all dates in the month
        var allDates: [Date?] = []

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                allDates.append(date)
            }
        }

        // Pad beginning of first week with nils if first date is not start of the week
        if let firstDate = allDates.first {
            guard let dateFirst = firstDate else { return }
            let weekday = calendar.component(.weekday, from: dateFirst)
            let paddingCount = (weekday - calendar.firstWeekday + 7) % 7
            for _ in 0..<paddingCount {
                allDates.insert(nil, at: 0)
            }
        }

        // Chunk into weeks
        var week: [Date?] = []
        for date in allDates {
            week.append(date)
            if week.count == 7 {
                allWeeks.append(week)
                week = []
            }
        }
        if !week.isEmpty {
            // Fill up the last week with trailing nils if needed
            while week.count < 7 {
                week.append(nil)
            }
            allWeeks.append(week)
        }

        // Reset to first week
        currentWeekIndex = 0
        calendarWeekView?.reloadData()
    }
    
    func goToNextWeek() {
        // If at last week currently
        if currentWeekIndex == allWeeks.count - 1 {
            // Load next month’s weeks and append
            if let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonthDate) {
                selectedMonthDate = nextMonthDate
                let newWeeks = generateWeeks(for: selectedMonthDate)
                allWeeks.append(contentsOf: newWeeks)
            }
        }
        
        // Move to next week
        if currentWeekIndex < allWeeks.count - 1 {
            currentWeekIndex += 1
            reloadWeekView()
        }
    }

    func goToPreviousWeek() {
        if currentWeekIndex == 0 {
            // Load previous month’s weeks and prepend
            if let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonthDate) {
                selectedMonthDate = previousMonthDate
                let newWeeks = generateWeeks(for: selectedMonthDate)
                allWeeks.insert(contentsOf: newWeeks, at: 0)
                
                // Shift currentWeekIndex forward by newWeeks.count
                currentWeekIndex += newWeeks.count
            }
        }
        
        // Move to previous week
        if currentWeekIndex > 0 {
            currentWeekIndex -= 1
            reloadWeekView()
        }
    }
    
    func generateWeeks(for monthDate: Date) -> [[Date?]] {
        var weeks: [[Date?]] = []
        let calendar = Calendar.current
        
        guard let range = calendar.range(of: .day, in: .month, for: monthDate),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate)) else {
            return []
        }
        
        var dates: [Date?] = []
        
        // 1️⃣ Find weekday of 1st of month
        let weekdayOfFirst = calendar.component(.weekday, from: monthStart)
        let leadingEmptyDays = weekdayOfFirst - calendar.firstWeekday
        let emptyCount = leadingEmptyDays >= 0 ? leadingEmptyDays : (7 + leadingEmptyDays)
        
        // 2️⃣ Fill leading nils
        for _ in 0..<emptyCount {
            dates.append(nil)
        }
        
        // 3️⃣ Fill actual month days
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                dates.append(date)
            }
        }
        
        // 4️⃣ Pad trailing nils to complete last week
        while dates.count % 7 != 0 {
            dates.append(nil)
        }
        
        // 5️⃣ Split into weeks
        var i = 0
        while i < dates.count {
            let week = Array(dates[i..<i+7])
            weeks.append(week)
            i += 7
        }
        
        return weeks
    }
    
    func reloadWeekView() {
        let week = allWeeks[currentWeekIndex]
        weekDates = week
        
        //Find the first non-nil date in the week to determine the month
        if let visibleDate = week.compactMap({ $0 }).first {
            updateMonthLabel(using: visibleDate)
        }

        
        //self.setupCalendarHeaders()
        cellSelectedToHighlight = -1
        calendarWeekView?.reloadData()
    }
    
    func updateMonthLabel(using date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy" // e.g. August 2025
        let monthYear = formatter.string(from: date)
        labelCurrentWeekMonth?.text = monthYear
    }
    
    func isFirstWeekOfMonth(_ date: Date) -> Bool {
        let day = Calendar.current.component(.day, from: date)
        return day <= 7
    }

    func isLastWeekOfMonth(_ date: Date) -> Bool {
        guard let range = Calendar.current.range(of: .day, in: .month, for: date) else { return false }
        let day = Calendar.current.component(.day, from: date)
        return day >= (range.count - 6)
    }
    
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0 // space between columns (horizontal spacing)
        layout.minimumLineSpacing = 2       // 🔽 space between rows (vertical spacing)

        let totalWidth = self.bounds.width
        let cellWidth = totalWidth / 7
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)

        calendarWeekView?.collectionViewLayout = layout
    }
    
    //MARK: - Button Action Methods -
    @IBAction func buttonPreviousWeek(_ sender: Any) {
        goToPreviousWeek()
    }
    
    @IBAction func buttonNextWeek(_ sender: Any) {
        goToNextWeek()
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarWeekView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7//weekDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarWeekView?.dequeueReusableCell(withReuseIdentifier: "RVCalendarCollectionViewCell", for: indexPath) as! RVCalendarCollectionViewCell
        
        if let date = currentWeek[indexPath.item] {
            //let date = weekDates[indexPath.item]
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            cell.labelDate.text = formatter.string(from: date)
            cell.isUserInteractionEnabled = true
            cell.labelDate.textColor = .black
        } else {
            cell.labelDate.text = ""
            cell.isUserInteractionEnabled = false
            cell.labelDate.textColor = .clear // or inactive color
        }
        
        if cell.labelDate.text != "" {
            if dictDateEventArrayColors.count > 0 {
                let currentCellDate = getDateForSelectedCell(atIndex: indexPath.item)
                if let arrayColors = dictDateEventArrayColors[currentCellDate] {
                    cell.setEventDateDotsWith(colors: arrayColors)
                }
            }
        }
        
        if cellSelectedToHighlight != -1 {
            cell.viewDateLabelSelection.backgroundColor = dateSelectionColor
        } else {
            cell.viewDateLabelSelection.backgroundColor = .clear
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
                print("Selected Date: \(selectedDateValue)")

                //MARK: - Delegate Method For Date Selection -
                weekViewCalendarDelegate?.dateSelected(dateString: selectedDateValue)
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
        //--
        let date = currentWeek[atIndex]
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        guard let dateValue = date else { return "" }
        let strDay = formatter.string(from: dateValue)
        //--
        let day = Int(strDay)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedStartDate)
        
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
extension CalendarWeekView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //----- Common Cell Size Setup For Both View Type -----
            let width = (collectionView.frame.width - 2) / 7
            let height = (collectionView.frame.height - 2) // 6
            return CGSize(width: width, height: height)
    }
}
