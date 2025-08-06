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
    private var weekDates: [Date] = []
    private var cellSelectedToHighlight = -1
    var dateSelectionColor = UIColor.white
   
    private var selectedDate = Date()
    
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
    }
    
    func setupCalendarHeaders() {
        let monthLabelText = CalendarHelper().monthYearString(date: selectedDate)
        labelCurrentWeekMonth?.text = monthLabelText
    }
    
    func setDateSelectionColor(colorName: UIColor) {
        dateSelectionColor = colorName
    }
    
    func setupWeekView() {
        weekDates.removeAll()
        for i in 0..<7 {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: selectedStartDate) {
                weekDates.append(date)
            }
        }
        
        calendarWeekView?.reloadData()
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
        return weekDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarWeekView?.dequeueReusableCell(withReuseIdentifier: "RVCalendarCollectionViewCell", for: indexPath) as! RVCalendarCollectionViewCell
        
        let date = weekDates[indexPath.item]
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        cell.labelDate.text = formatter.string(from: date)
        
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
                
                //MARK: - Create Delegate Method For Date Selection Here -
                //calendarDelegate?.dateSelected(dateString: selectedDateValue)
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
        let date = weekDates[atIndex]
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let strDay = formatter.string(from: date)
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
            let height = (collectionView.frame.height - 2) / 6
            return CGSize(width: width, height: height)
    }
}
