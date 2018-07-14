//
//  WQDate+Format.swift
//  
//
//  Created by hejinyin on 2018/1/21.
//  swiftlint:disable identifier_name

import Foundation

/// A:表示`-` B表示 `:` C表示` ` 1表示`/` k表示4个y
public enum DateFormatEnum: String {
    /// yyyy
    case k
    /// yyyy年
    case k年
    
    /// yyyy-MM
    case kAMM
    /// yyyy/MM
    case k1MM
    /// yyyy年MM月
    case k年MM月
    
    /// yyyy-MM-dd
    case kAMMAdd
    /// yyyy/MM/dd
    case k1MM1dd
    /// yyyy年MM月dd日
    case k年MM月dd日
    
    /// yyyyMMddHHmm
    case kMMddHHmm
    /// yyyy-MM-dd HH:mm
    case kAMMAddCHHBmm
    /// yyyy/MM/dd HH:mm
    case k1MM1ddCHHBmm
    /// yyyy年MM月dd日HH时mm分
    case k年MM月dd日HH时mm分
    
    /// yyyyMMddHHmmss
    case kMMddHHmmss
    /// yyyy-MM-dd HH:mm:ss
    case kAMMAddCHHBmmBss
    /// yyyy/MM/dd HH:mm:ss
    case k1MM1ddCHHBmmBss
    /// yyyy年MM月dd日HH时mm分ss秒
    case k年MM月dd日HH时mm分ss秒
    /// M
    case M
    /// M月
    case M月
    
    /// MM
    case MM
    /// MM
    case MM月
    
    /// MM-dd
    case MMAdd
    /// MM/dd
    case MM1dd
    /// MM月dd日
    case MM月dd日
    
    /// MM-dd HH:ss
    case MMAddCHHBss
    /// MM/dd HH:ss
    case MM1ddCHHBss
    /// MM月dd日HH时mm分
    case MM月dd日HH时mm分
    
    /// MM-dd HH:mm:ss
    case MMAddCHHBmmBss
    /// MM/dd HH:mm:ss
    case MM1ddCHHBmmBss
    /// MM月dd日HH时mm分ss秒
    case MM月dd日HH时mm分ss秒
    
    /// d
    case d
    /// d日
    case d日
    
    /// dd
    case dd
    /// dd日
    case dd日
   
    case HH
    case HH时
    
    /// HH:mm
    case HHBmm
    /// HH时mm分
    case HH时mm分
    
    /// HH:mm:ss
    case HHBmmBss
    /// HH时mm分ss秒
    case HH时mm分ss秒
 
    case E
    
    internal var formatString: String {
            var format = rawValue
            do {
                let regularExpression = try NSRegularExpression(pattern: "[ABCk]{1}", options: [])
                let matchRange = NSRange(location: 0, length: rawValue.count)
                let results = regularExpression.matches(in: rawValue, options: [], range: matchRange)
                format = results.reversed().reduce(rawValue, { fmtStr, result -> String in
                    let start = fmtStr.index(fmtStr.startIndex, offsetBy: result.range.location)
                    let end = fmtStr.index(start, offsetBy: result.range.length)
                    let range = start ..< end
                    
                    let match = fmtStr[range]
                    var replaceStr: String
                    switch match {
                    case "A":
                        replaceStr = "-"
                    case "B":
                        replaceStr = ":"
                    case "C":
                        replaceStr = " "
                    case "k":
                        replaceStr = "yyyy"
                    default:
                        replaceStr = String(match)
                    }
                    let resultStr = fmtStr.replacingOccurrences(of: match, with: replaceStr, options: [], range: range)
                    
                    return resultStr
                })
            } catch {
                debugPrint(error)
            }
            return format
    }
}

public extension Date { // MARK: 日期格式化
    /// convert date to string
    ///
    /// - Parameter dateFormat: enum dateFormatString
    /// - Returns: date string
    func toString(_ dateFormat: DateFormatEnum, in calendar: Calendar = .current) -> String {
        WQDateFormatter.shared.dateFormat = dateFormat.formatString
        WQDateFormatter.shared.calendar = calendar
        return WQDateFormatter.shared.string(from: self)
    }
}
public extension String { // MARK: 字符串转日期

    /// convert date format string to date
    ///
    /// - Parameter dateFormat: enum dateFormatString
    /// - Returns: if error return now date
    func toDate(format dateFormat: DateFormatEnum, in calendar: Calendar = .current) -> Date {
        WQDateFormatter.shared.dateFormat = dateFormat.formatString
        WQDateFormatter.shared.calendar = calendar
        guard let date = WQDateFormatter.shared.date(from: self) else {
            return Date()
        }
        return date
    }
}
