//
//  NSDate+Extension.swift
//  FPSwift
//
//  Created by iblue on 16/7/10.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

enum FPDateFormat: String {
    case Default = "yyyy-MM-dd HH:mm:ss"
    case Hour = "HH:mm:ss"
    case Minitue = "mm:ss"
    case Year = "yyyy年MM月dd日"
    case DateWithMoth = "MM-dd"
    case YearAndMinute = "yyyy年MM月dd日 HH:mm"
    case ChnYearAndMinute = "yyyy年MM月dd日 aHH:mm"
}

extension Date {
    
    static func fp_date(string: String, format: FPDateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.date(from: string)
    }
    
    static func fp_date(string: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
    
    func fp_string(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    func fp_string(_ format: FPDateFormat) ->String {
        return self.fp_string(format.rawValue)
    }
    
    func fp_localizeDayOfWeek() -> String {
        let componets = (Date.fp_currentCalendar() as NSCalendar).component(.weekday, from: self)
        let weekdays = ["周日", "周六", "周五", "周四", "周三", "周二", "周一"]
        if componets < weekdays.count {
            return weekdays[componets]
        }
        
        return ""
    }
    
    /**
     GMT的时间转化成String格式
     
     - parameter time:   timeIntervalSince1970
     - parameter format: 格式
     
     - returns: 返回后的日期
     */
    static func fp_string(timeInterval time: TimeInterval, format: FPDateFormat) -> String {
        let date = Date(timeIntervalSince1970: time)
        return date.fp_string(format.rawValue)
    }
    
    static func fp_currentCalendar() -> Calendar {
        return Calendar.autoupdatingCurrent
        
    }
    
    /// 返回昨天等形式
    ///
    /// - Parameter time: 时间
    /// - Returns: 字符串
    static func fp_localizedString(timeInterval time: TimeInterval) -> String {
        var result: String = ""
        
        //统一转化为 yyyy年MM月dd日 00:00:00进行比较
        let strCompare = self.fp_string(timeInterval: time, format: .Year)
        let compareDate = Date.fp_date(string: strCompare, format: .Year)!
        let strToday = Date().fp_string(.Year)
        let todayDate = Date.fp_date(string: strToday, format: .Year)!
        
        let timeDiff = todayDate.timeIntervalSince(compareDate)
        if timeDiff == FP_SECONDS_DAY {
            result = Date(timeIntervalSince1970: time).fp_string("昨天 HH:mm")
        } else if timeDiff == 0 {
            result = Date(timeIntervalSince1970: time).fp_string("今天 HH:mm")
        } else {
            result = Date(timeIntervalSince1970: time).fp_string(.YearAndMinute)
        }
        
        return result
    }
    
    /// 返回当天的开始
    ///
    /// - Returns: Date
    func fp_startOfDay() -> Date {
        let format = "yyyy-MM-dd 00:00:00"
        let strDate = self.fp_string(format)
        return Date.fp_date(string: strDate, format: format)!
    }
    
    /// 返回当天的结束
    ///
    /// - Returns: Date
    func fp_endOfDay() -> Date {
        let format = "yyyy-MM-dd 23:59:59"
        let strDate = self.fp_string(format)
        return Date.fp_date(string: strDate, format: format)!
    }
}


