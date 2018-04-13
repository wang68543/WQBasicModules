//
//  WQDate+Format.swift
//  
//
//  Created by hejinyin on 2018/1/21.
//

import Foundation

/// 0表示`-`  1表示`/` 2表示`空格` 3表示`:` 其它字符不变
public enum DateFormatString: String {
    /// yyyy-MM-dd
    case yyyy0MM0dd
    /// yyyy/MM/dd
    case yyyy1MM1dd
    /// yyyy-MM-dd HH:mm:ss
    case yyyy0MM0dd2HH3mm3ss
    
    /// yyyy年MM月dd日
    case yyyy年MM月dd日
 
    internal var formatString: String {
            var format = rawValue
            do {
                let regularExpression = try NSRegularExpression.init(pattern: "[01234]{1}", options: [])
                let matchRange = NSRange.init(location: 0, length: rawValue.count)
                let results = regularExpression.matches(in: rawValue, options: [], range: matchRange)
                format = results.reversed().reduce(rawValue, { (fmtStr, result) -> String in
                    let start = fmtStr.index(fmtStr.startIndex, offsetBy: result.range.location)
                    let end = fmtStr.index(start, offsetBy: result.range.length)
                    let range = start ..< end
                    
                    let match = fmtStr[range]
                    var replaceStr: String 
                    switch match {
                    case "0":
                        replaceStr = "-"
                    case "1":
                        replaceStr = "/"
                    case "2":
                        replaceStr = " "
                    case "3":
                        replaceStr = ":"
//                    case "4":
//                        replaceStr = "-"
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

// MARK: =========== 日期格式化 ===========
extension Date {
    
    /// convert date to string
    ///
    /// - Parameter dateFormat: enum dateFormatString
    /// - Returns: date string
    public func toString(format dateFormat: DateFormatString, in calendar: Calendar = .current) -> String {
        WQDateFormatter.shared.dateFormat = dateFormat.formatString
        WQDateFormatter.shared.calendar = calendar
        return WQDateFormatter.shared.string(from: self)
    }
}
// MARK: =========== 字符串转日期 ===========
extension String {

    /// convert date format string to date
    ///
    /// - Parameter dateFormat: enum dateFormatString
    /// - Returns: if error return now date
    public func toDate(format dateFormat: DateFormatString, in calendar: Calendar = .current) -> Date {
        WQDateFormatter.shared.dateFormat = dateFormat.formatString
        WQDateFormatter.shared.calendar = calendar
        guard let date =  WQDateFormatter.shared.date(from: self) else {
            return Date()
        }
        return date
    }
}
