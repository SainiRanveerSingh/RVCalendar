//
//  RVCalendarCollectionViewCell.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import UIKit

class RVCalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMainCellBackground: UIView!
    @IBOutlet weak var viewDateLabelSelection: UIView!
    @IBOutlet weak var viewDateLabelBackground: UIView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var viewToShowFourEventDots: UIView!
    @IBOutlet weak var imageViewDateHighlighter: UIImageView!
    var cellColor = UIColor.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    func initialSetup() {
        //viewDateLabelBackground.backgroundColor = cellColor
        viewDateLabelBackground.layer.cornerRadius = viewDateLabelBackground.frame.size.height / 2.0
    }
    
    func configure(with day: String, index: Int) {
        labelDate.text = day
        labelDate.tag = 1000 + index
        viewDateLabelBackground.tag = 2000 + index
        viewToShowFourEventDots.tag = 3000 + index
        imageViewDateHighlighter.tag = 4000 + index
    }
    
}
