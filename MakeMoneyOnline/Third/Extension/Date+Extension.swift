//
//  NSDate+Extension.swift
//  Pick记账
//
//  Created by Dev on 2023/6/21.
//

import Foundation
import SwifterSwift

extension Date {
    
    static func earlierDate(_ date1: Date?, _ date2: Date?) -> Date? {
        guard let date1 = date1, let date2 = date2 else { return nil }
        return date1.timeIntervalSince1970 < date2.timeIntervalSince1970 ? date1 : date2
    }
    
    static func laterDate(_ date1: Date?, _ date2: Date?) -> Date? {
        guard let date1 = date1, let date2 = date2 else { return nil }
        return date1.timeIntervalSince1970 > date2.timeIntervalSince1970 ? date1 : date2
    }
    
    var zeroDate: Date? {
        return Date(year: self.year, month: self.month, day: self.day)
    }
    
    var secondValue: Int64 {
        return Int64(self.timeIntervalSince1970)
    }
    
    var millisecondValue: Int64 {
        let second = Int64(self.timeIntervalSince1970)
        return second * 1000
    }

    var microsecondValue: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000000)
    }
    
    init?(millisecondTimestamp: Int64) {
        if millisecondTimestamp <= 0 {
            return nil
        }
        self.init(timeIntervalSince1970: Double(millisecondTimestamp / 1000))
    }
    
    /// 获取本周开始时间，周一为每周的第一天
    /// - Parameter firstWeekday: //设定每周的第一天从星期几开始 0-参照日历 1-星期日 2-星期一
    /// - Returns: 本周开始时间
    func cnWeekStartDate() -> Date? {
        return self.zeroDate?.weekStartDate(withFirstWeekday: 2)
    }
    
    /// 获取本周开始时间
    /// - Parameter firstWeekday: //设定每周的第一天从星期几开始 0-参照日历 1-星期日 2-星期一
    /// - Returns: 本周开始时间
    func weekStartDate(withFirstWeekday firstWeekday: Int) -> Date? {
        let calendar = Calendar.current
        
        if !(firstWeekday >= 1 && firstWeekday <= 7) { // firstWeekday不满足[1,7]，以日历为准
            let calendarFirstWeekday = calendar.firstWeekday
            return weekStartDate(withFirstWeekday: calendarFirstWeekday)
        }
        
        var offsetComponents = DateComponents()
        let weekday = calendar.component(.weekday, from: self)
        offsetComponents.day = 0 - (7 + weekday - firstWeekday) % 7
        
        return calendar.date(byAdding: offsetComponents, to: self)
    }
    
    func cl_format(with dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.posix
        
        return dateFormatter.string(from: self)
    }
    
    static func cl_date(dateString: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.posix
        
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    // MARK: Pick专用
    
    var cl_billDayString: String {
        let dateString = self.cl_format(with: "yyyyMMddHHmmss")
        
        return dateString
    }

    var cl_billDayLongValue: Int64 {
        return Int64(self.cl_billDayString) ?? 0
    }
    
    
    func cl_weekDay() -> String {
        switch self.weekday {
        case 1: return "周日"
        case 2: return "周一"
        case 3: return "周二"
        case 4: return "周三"
        case 5: return "周四"
        case 6: return "周五"
        case 7: return "周六"
        default: return ""
        }
    }
    
    /// 仅聊天页面用
    func cl_weekDay_chat() -> String {
        switch self.weekday {
        case 1: return "星期天"
        case 2: return "星期一"
        case 3: return "星期二"
        case 4: return "星期三"
        case 5: return "星期四"
        case 6: return "星期五"
        case 7: return "星期六"
        default: return ""
        }
    }
    
    func daysInThisMonth() -> Int {
        return Date().daysInThisMonth()
    }
    
    func widgetDay() -> Int {
        return Date().day
    }
}

func getWeekOne() -> [String] {
    return ["一", "二", "三", "四", "五", "六", "七"]
}

func getWeek() -> [String] {
    return ["日", "一", "二", "三", "四", "五", "六"]
}

func getMonth() -> [String] {
    return ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
}

func getMonthNumber() -> [String] {
    return ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
}
