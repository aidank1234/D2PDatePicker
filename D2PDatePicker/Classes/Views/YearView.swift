//
//  YearView.swift
//  Token
//
//  Created by Pradheep Rajendirane on 10/08/2017.
//  Copyright © 2017 DI2PRA. All rights reserved.
//

import UIKit

class YearView: AnimateView {
    
    @IBOutlet weak var yearLabel:UILabel!
    
    func anim(direction: AnimationDirection, date: Date) -> Date {
        
        let dateFormatter = DateFormatter()
        var newDate:Date
        
        if direction == .backward {
            newDate = Calendar.current.date(byAdding: .year, value: -1, to: date)!
        } else if direction == .forward {
            newDate = Calendar.current.date(byAdding: .year, value: 1, to: date)!
        } else {
            newDate = date
        }
        
        dateFormatter.dateFormat = "yyyy"
        
        // Init animation
        
        self.yearLabel.text = dateFormatter.string(from: newDate)
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
