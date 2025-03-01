//
//  D2PDatePicker.swift
//  D2PDatePicker
//
//  Created by Pradheep Rajendirane on 09/08/2017.
//  Copyright © 2017 DI2PRA. All rights reserved.
//

import UIKit

public protocol D2PDatePickerDelegate: class {
    func didChange(toDate date: Date)
}

public class D2PDatePicker: UIView {
    
    public weak var delegate: D2PDatePickerDelegate?
    
    @IBOutlet private weak var topView:UIView!
    @IBOutlet private weak var middleView:UIView!
    @IBOutlet private weak var bottomView:UIView!
    
    @IBOutlet private weak var dayNextBtn:UIButton!
    @IBOutlet private weak var dayPrevBtn:UIButton!
    
    @IBOutlet private weak var monthNextBtn:UIButton!
    @IBOutlet private weak var monthPrevBtn:UIButton!
    
    @IBOutlet private weak var yearNextBtn:UIButton!
    @IBOutlet private weak var yearPrevBtn:UIButton!
    
    @IBOutlet private  weak var dayView:DayView!
    @IBOutlet private weak var monthView:MonthView!
    @IBOutlet private weak var yearView:YearView!
    
    
    private var selectedDate:Date! = Date() {
        didSet {
            delegate?.didChange(toDate: selectedDate)
        }
    }
    
    private var minDate: Date! = Date()
    private var maxDate: Date! = Date()
    
    
    required public init?(coder aDecoder: NSCoder) {   // 2 - storyboard initializer
        super.init(coder: aDecoder)
        
        fromNib()   // 5.
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())  // 4.
        fromNib()  // 6.
    }
    
    public convenience init(frame: CGRect, date: Date) {
        
        self.init(frame: frame)
        self.selectedDate = date
        self.awakeFromNib()
        
    }
    
    public var mainColor: UIColor! = UIColor(red:0.99, green:0.28, blue:0.25, alpha:1.0) { // #FD4741
        didSet {
            self.topView.backgroundColor = mainColor
            self.dayView.weekDayLabel.textColor = mainColor
        }
    }
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // topView Rounded Corner
        self.topView.layer.cornerRadius = 10.0
        self.topView.clipsToBounds = true
        
        
        // middleView Border
        self.middleView.layer.borderWidth = 1.0
        self.middleView.layer.borderColor = UIColor.AppColors.normalGreen.cgColor
        
        // bottomView Rounded Corner & border
        self.bottomView.layer.cornerRadius = 10.0
        self.bottomView.layer.borderWidth = 1.0
        self.bottomView.layer.borderColor = UIColor.AppColors.normalGreen.cgColor
        
        
        
        // setting buttons
        self.monthPrevBtn.tag = 0
        self.monthPrevBtn.addTarget(self, action: #selector(self.changeDate), for: .touchUpInside)
        
        self.monthNextBtn.tag = 1
        self.monthNextBtn.addTarget(self, action: #selector(self.changeDate), for: .touchUpInside)
        
        self.dayPrevBtn.tag = 2
        self.dayPrevBtn.addTarget(self, action: #selector(self.changeDate), for: .touchUpInside)
        
        self.dayNextBtn.tag = 3
        self.dayNextBtn.addTarget(self, action: #selector(self.changeDate), for: .touchUpInside)
        
        
        self.yearPrevBtn.tag = 4
        self.yearPrevBtn.addTarget(self, action: #selector(self.changeDate), for: .touchUpInside)
        
        self.yearNextBtn.tag = 5
        self.yearNextBtn.addTarget(self, action: #selector(self.changeDate), for: .touchUpInside)
        
        
        setLabel(toDate: selectedDate)
        
    }
    
    public func set(toDate date: Date) {
        setLabel(toDate: date)
        self.selectedDate = date
    }
    
    public func setMaxAndMinDates(minDate: Date, maxDate: Date) {
        self.minDate = minDate
        self.maxDate = maxDate
        
        let oneMonthBackFromChange = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
        if oneMonthBackFromChange < minDate {
            monthPrevBtn.isHidden = true
        }
        let oneDayBackFromChange = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
        if oneDayBackFromChange < minDate {
            dayPrevBtn.isHidden = true
        }
        let oneYearBackFromChange = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? Date()
        if oneYearBackFromChange < minDate {
            yearPrevBtn.isHidden = true
        }
        
        let oneMonthForwardFromChange = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
        if oneMonthForwardFromChange > maxDate {
            monthNextBtn.isHidden = true
        }
        let oneDayForwardFromChange = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
        if oneDayForwardFromChange > maxDate {
            dayNextBtn.isHidden = true
        }
        let oneYearForwardFromChange = Calendar.current.date(byAdding: .year, value: 1, to: selectedDate) ?? Date()
        if oneYearForwardFromChange > maxDate {
            yearNextBtn.isHidden = true
        }
    }
    
    private func setLabel(toDate date: Date) {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM"
        self.monthView.monthLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "dd"
        self.dayView.dayLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "EEEE"
        self.dayView.weekDayLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "YYYY"
        self.yearView.yearLabel.text = formatter.string(from: date)
    }
    
    @objc private func changeDate(btn: UIButton) {
        
        if btn.tag == 0 {
            let oneMonthBack = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
            if oneMonthBack >= minDate {
                selectedDate = self.monthView.anim(direction: .backward, date: selectedDate)
                _ = self.dayView.anim(direction: .identity, date: selectedDate)
                _ = self.yearView.anim(direction: .identity, date: selectedDate)
                
                let oneMonthBackFromChange = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
                if oneMonthBackFromChange < minDate {
                    monthPrevBtn.isHidden = true
                }
                let oneDayBackFromChange = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
                if oneDayBackFromChange < minDate {
                    dayPrevBtn.isHidden = true
                }
                let oneYearBackFromChange = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? Date()
                if oneYearBackFromChange < minDate {
                    yearPrevBtn.isHidden = true
                }
                
                let oneMonthForwardFromChange = Calendar.current.date(byAdding: .month, value: 1, to: oneMonthBack) ?? Date()
                if oneMonthForwardFromChange <= maxDate {
                    monthNextBtn.isHidden = false
                }
                let oneDayForwardFromChange = Calendar.current.date(byAdding: .day, value: 1, to: oneMonthBack) ?? Date()
                if oneDayForwardFromChange <= maxDate {
                    dayNextBtn.isHidden = false
                }
                let oneYearForwardFromChange = Calendar.current.date(byAdding: .year, value: 1, to: oneMonthBack) ?? Date()
                if oneYearForwardFromChange <= maxDate {
                    yearNextBtn.isHidden = false
                }
            }
        } else if btn.tag == 1 {
            let oneMonthForward = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
            if oneMonthForward <= maxDate {
                selectedDate =  self.monthView.anim(direction: .forward, date: selectedDate)
                _ = self.dayView.anim(direction: .identity, date: selectedDate)
                _ = self.yearView.anim(direction: .identity, date: selectedDate)
                
                let oneMonthBackFromChange = Calendar.current.date(byAdding: .month, value: -1, to: oneMonthForward) ?? Date()
                if oneMonthBackFromChange >= minDate {
                    monthPrevBtn.isHidden = false
                }
                let oneDayBackFromChange = Calendar.current.date(byAdding: .day, value: -1, to: oneMonthForward) ?? Date()
                if oneDayBackFromChange >= minDate {
                    dayPrevBtn.isHidden = false
                }
                let oneYearBackFromChange = Calendar.current.date(byAdding: .year, value: -1, to: oneMonthForward) ?? Date()
                if oneYearBackFromChange >= minDate {
                    yearPrevBtn.isHidden = false
                }
                
                let oneMonthForwardFromChange = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
                if oneMonthForwardFromChange > maxDate {
                    monthNextBtn.isHidden = true
                }
                let oneDayForwardFromChange = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
                if oneDayForwardFromChange > maxDate {
                    dayNextBtn.isHidden = true
                }
                let oneYearForwardFromChange = Calendar.current.date(byAdding: .year, value: 1, to: selectedDate) ?? Date()
                if oneYearForwardFromChange > maxDate {
                    yearNextBtn.isHidden = true
                }
                
            }
            
        } else if btn.tag == 2 {
            let oneDayBack = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
            if oneDayBack >= minDate {
                selectedDate = self.dayView.anim(direction: .backward, date: selectedDate)
                _ = self.monthView.anim(direction: .identity, date: selectedDate)
                _ = self.yearView.anim(direction: .identity, date: selectedDate)
                
                let oneMonthBackFromChange = Calendar.current.date(byAdding: .month, value: -1, to: oneDayBack) ?? Date()
                if oneMonthBackFromChange < minDate {
                    monthPrevBtn.isHidden = true
                }
                let oneDayBackFromChange = Calendar.current.date(byAdding: .day, value: -1, to: oneDayBack) ?? Date()
                if oneDayBackFromChange < minDate {
                    dayPrevBtn.isHidden = true
                }
                let oneYearBackFromChange = Calendar.current.date(byAdding: .year, value: -1, to: oneDayBack) ?? Date()
                if oneYearBackFromChange < minDate {
                    yearPrevBtn.isHidden = true
                }
                
                let oneMonthForwardFromChange = Calendar.current.date(byAdding: .month, value: 1, to: oneDayBack) ?? Date()
                if oneMonthForwardFromChange <= maxDate {
                    monthNextBtn.isHidden = false
                }
                let oneDayForwardFromChange = Calendar.current.date(byAdding: .day, value: 1, to: oneDayBack) ?? Date()
                if oneDayForwardFromChange <= maxDate {
                    dayNextBtn.isHidden = false
                }
                let oneYearForwardFromChange = Calendar.current.date(byAdding: .year, value: 1, to: oneDayBack) ?? Date()
                if oneYearForwardFromChange <= maxDate {
                    yearNextBtn.isHidden = false
                }
            }
            
        } else if btn.tag == 3 {
            let oneDayForward = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
            if oneDayForward <= maxDate {
                selectedDate = self.dayView.anim(direction: .forward, date: selectedDate)
                _ = self.monthView.anim(direction: .identity, date: selectedDate)
                _ = self.yearView.anim(direction: .identity, date: selectedDate)
                
                let oneMonthBackFromChange = Calendar.current.date(byAdding: .month, value: -1, to: oneDayForward) ?? Date()
                if oneMonthBackFromChange >= minDate {
                    monthPrevBtn.isHidden = false
                }
                let oneDayBackFromChange = Calendar.current.date(byAdding: .day, value: -1, to: oneDayForward) ?? Date()
                if oneDayBackFromChange >= minDate {
                    dayPrevBtn.isHidden = false
                }
                let oneYearBackFromChange = Calendar.current.date(byAdding: .year, value: -1, to: oneDayForward) ?? Date()
                if oneYearBackFromChange >= minDate {
                    yearPrevBtn.isHidden = false
                }
                
                let oneMonthForwardFromChange = Calendar.current.date(byAdding: .month, value: 1, to: oneDayForward) ?? Date()
                if oneMonthForwardFromChange > maxDate {
                    monthNextBtn.isHidden = true
                }
                let oneDayForwardFromChange = Calendar.current.date(byAdding: .day, value: 1, to: oneDayForward) ?? Date()
                if oneDayForwardFromChange > maxDate {
                    dayNextBtn.isHidden = true
                }
                let oneYearForwardFromChange = Calendar.current.date(byAdding: .year, value: 1, to: oneDayForward) ?? Date()
                if oneYearForwardFromChange > maxDate {
                    yearNextBtn.isHidden = true
                }
            }
            
        } else if btn.tag == 4 {
            let oneYearBack = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? Date()
            if oneYearBack >= minDate {
                selectedDate = self.yearView.anim(direction: .backward, date: selectedDate)
                _ = self.dayView.anim(direction: .identity, date: selectedDate)
                _ = self.monthView.anim(direction: .identity, date: selectedDate)
                
                let oneMonthBackFromChange = Calendar.current.date(byAdding: .month, value: -1, to: oneYearBack) ?? Date()
                if oneMonthBackFromChange < minDate {
                    monthPrevBtn.isHidden = true
                }
                let oneDayBackFromChange = Calendar.current.date(byAdding: .day, value: -1, to: oneYearBack) ?? Date()
                if oneDayBackFromChange < minDate {
                    dayPrevBtn.isHidden = true
                }
                let oneYearBackFromChange = Calendar.current.date(byAdding: .year, value: -1, to: oneYearBack) ?? Date()
                if oneYearBackFromChange < minDate {
                    yearPrevBtn.isHidden = true
                }
                
                let oneMonthForwardFromChange = Calendar.current.date(byAdding: .month, value: 1, to: oneYearBack) ?? Date()
                if oneMonthForwardFromChange <= maxDate {
                    monthNextBtn.isHidden = false
                }
                let oneDayForwardFromChange = Calendar.current.date(byAdding: .day, value: 1, to: oneYearBack) ?? Date()
                if oneDayForwardFromChange <= maxDate {
                    dayNextBtn.isHidden = false
                }
                let oneYearForwardFromChange = Calendar.current.date(byAdding: .year, value: 1, to: oneYearBack) ?? Date()
                if oneYearForwardFromChange <= maxDate {
                    yearNextBtn.isHidden = false
                }
            }
            
        } else if btn.tag == 5 {
            let oneYearForward = Calendar.current.date(byAdding: .year, value: 1, to: selectedDate) ?? Date()
            if oneYearForward <= maxDate {
                selectedDate = self.yearView.anim(direction: .forward, date: selectedDate)
                _ = self.dayView.anim(direction: .identity, date: selectedDate)
                _ = self.monthView.anim(direction: .identity, date: selectedDate)
                
                let oneMonthBackFromChange = Calendar.current.date(byAdding: .month, value: -1, to: oneYearForward) ?? Date()
                if oneMonthBackFromChange >= minDate {
                    monthPrevBtn.isHidden = false
                }
                let oneDayBackFromChange = Calendar.current.date(byAdding: .day, value: -1, to: oneYearForward) ?? Date()
                if oneDayBackFromChange >= minDate {
                    dayPrevBtn.isHidden = false
                }
                let oneYearBackFromChange = Calendar.current.date(byAdding: .year, value: -1, to: oneYearForward) ?? Date()
                if oneYearBackFromChange >= minDate {
                    yearPrevBtn.isHidden = false
                }
                
                let oneMonthForwardFromChange = Calendar.current.date(byAdding: .month, value: 1, to: oneYearForward) ?? Date()
                if oneMonthForwardFromChange > maxDate {
                    monthNextBtn.isHidden = true
                }
                let oneDayForwardFromChange = Calendar.current.date(byAdding: .day, value: 1, to: oneYearForward) ?? Date()
                if oneDayForwardFromChange > maxDate {
                    dayNextBtn.isHidden = true
                }
                let oneYearForwardFromChange = Calendar.current.date(byAdding: .year, value: 1, to: oneYearForward) ?? Date()
                if oneYearForwardFromChange > maxDate {
                    yearNextBtn.isHidden = true
                }
            }
            
        }
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
