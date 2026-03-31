//
//  Date+AppExtension.swift
//  Pick记账
//
//  Created by eagle on 2024/10/18.
//

import Foundation

// MARK: Pick专用

extension Date {
    
//    func cl_yearStartDate(startDay: Int = PKAppHelper.currMonthStartDay) -> Date {
//        let now = self.zeroDate!
//        let startDate = Date.cl_yearStartDate(year: now.year, startDay: startDay)
//        
//        if now.year == startDate.year, now.isEarlier(than: startDate) {
//            return Date.cl_yearStartDate(year: now.subtract(1.years).year, startDay: startDay)
//        }
//        
//        return startDate
//    }
//    
//    func cl_monthStartDate(start: Int = PKAppHelper.currMonthStartDay) -> Date {
//        
//        let startDay = min(max(start, 1), self.daysInMonth);
//        let date = self.day < startDay ? self.subtract(1.months) : self
//        
//        return Date.cl_monthStartDate(year: date.year, month: date.month, startDay: start)
//    }
//    
//    func cl_monthEndDate(startDay: Int = PKAppHelper.currMonthStartDay) -> Date {
//        return cl_nextMonthStartDate(startDay: startDay).subtract(1.days)
//    }
//    
//    func cl_nextMonthStartDate(startDay: Int = PKAppHelper.currMonthStartDay) -> Date {
//        let startDate = cl_monthStartDate(start: startDay)
//        
//        if self.day < startDate.day && self.month == startDate.month {
//            return startDate
//        }
//        
//        let nextMonthDate = Date(year: startDate.year, month: startDate.month, day: 1).add(1.months)
//        
//        return Date.cl_monthStartDate(year: nextMonthDate.year, month: nextMonthDate.month, startDay: startDay)
//    }
//    
//    static func cl_monthStartDate(year: Int, month: Int, startDay: Int = PKAppHelper.currMonthStartDay) -> Date {
//        let date = Date(year: year, month: month, day: 1)
//        let startDay = min(max(startDay, 1), date.daysInMonth);
//        
//        return Date(year: year, month: month, day: startDay)
//    }
//    
//    static func cl_yearStartDate(year: Int, startDay: Int = PKAppHelper.currMonthStartDay) -> Date {
//        return cl_monthStartDate(year: year, month: 1, startDay: startDay)
//    }
    
}
