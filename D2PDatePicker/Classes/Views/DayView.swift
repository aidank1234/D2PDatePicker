//
//  DayView.swift
//  Token
//
//  Created by Pradheep Rajendirane on 10/08/2017.
//  Copyright © 2017 DI2PRA. All rights reserved.
//

import UIKit

class DayView: AnimateView {
    
    @IBOutlet weak var dayLabel:UILabel!
    @IBOutlet weak var weekDayLabel:UILabel!
    
    
    func anim(direction: AnimationDirection, date: Date) -> Date {
        
        let dateFormatter = DateFormatter()
        var newDate:Date
        
        if direction == .backward {
            newDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        } else if direction == .forward {
            newDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        } else {
            newDate = date
        }
        
        dateFormatter.dateFormat = "dd"
        let dayString = dateFormatter.string(from: newDate)
        
        dateFormatter.dateFormat = "EEEE"
        let weekDayString = dateFormatter.string(from: newDate)
        
        // Init animation
        
        self.dayLabel.text = dayString
        self.weekDayLabel.text = weekDayString
        return newDate
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
