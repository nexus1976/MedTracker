//
//  Extensions.swift
//  MedTracker
//
//  Created by Daniel Graham on 1/29/23.
//

import Foundation

extension Date {
    var onlyDate: Date {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calender.date(from: dateComponents)!
        }
    }
}
