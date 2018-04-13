//
//  WQDate+Compare.swift
//  Pods
//
//  Created by hejinyin on 2018/1/26.
//

import Foundation

public let oneMinuteSeconds: TimeInterval = 60
public let oneHourSeconds: TimeInterval = 60 * oneMinuteSeconds
public let oneDaySeconds: TimeInterval = 24 * oneHourSeconds
public let oneWeekSeconds: TimeInterval = 7 * oneDaySeconds

// MARK: - DateUnit
//public enum Calendar.Component:Int {
//    case second = 1, minute ,hour ,day,month,year
//    case week = 100
//    case timeZone = 200
//}


// MARK: - Components
extension Date {
    public func year(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.year], from: self).year!
    }
    public func month(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.month], from: self).month!
    }
    public func day(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.day], from: self).day!
    }
    public func hour(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.hour], from: self).hour!
    }
    public func minute(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.minute], from: self).minute!
    }
    public func second(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.second], from: self).second!
    }
    public func weekday(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.weekday], from: self).weekday!
    }
    public func weekOfYear(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.weekOfYear], from: self).weekOfYear!
    }
    public func timeZone(_ calendar: Calendar = .current) -> TimeZone {
        return calendar.dateComponents([.timeZone], from: self).timeZone!
    }
}

// MARK: - Calculate
extension Date {
    
    
    /// calculate date 根据一年的第几周推算出这周的起始日期
    ///
    /// - Parameters:
    ///   - week: ordinality of week in year
    ///   - year: in year
    ///   - calendar: caculate calendar
    /// - Returns: the first day in week (Sun)
    static public func date(ordinality week:Int , in year:Int ,calendar: Calendar = .current) -> Date? {
        let  dateComponments = DateComponents(year: year, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)
        let yearStartDate = calendar.date(from: dateComponments)
        guard let startDate = yearStartDate else {
            return nil
        }
        //1~7 从周日开始
        let component = calendar.component(.weekday, from: startDate)
        let showDate = calendar.date(byAdding: .day, value: ( week - 1) * 7  - (component - 1) , to: startDate)
        return showDate
    }
    
    public func unitDistance(_ ohter: Date, at unit: Calendar.Component = .day, in calendar: Calendar = .current) -> TimeInterval {
         var distanceValue: TimeInterval = 0
        if #available(iOS 10.0, *) {
            distanceValue =  calendar.dateInterval(of: unit, for: ohter)!.duration
        } else {
            switch unit {
            case let unitType  where unitType.hashValue <= Calendar.Component.weekOfYear.hashValue:
                var unitSeconds: TimeInterval
                switch unitType {
                case .second:
                    unitSeconds = 1
                case .minute:
                    unitSeconds = oneMinuteSeconds
                case .hour:
                    unitSeconds = oneHourSeconds
                case .day:
                    unitSeconds = oneDaySeconds
                case .weekOfYear:
                    unitSeconds = oneWeekSeconds
                default:
                    unitSeconds = 1
                }
                distanceValue = timeIntervalSince(ohter)/unitSeconds
            case .month:
                distanceValue =  TimeInterval(calendar.dateComponents([unit], from: self, to: ohter).month!)
            case .year:
                distanceValue =  TimeInterval(calendar.dateComponents([unit], from: self, to: ohter).year!)
            default:
                break
            }
        }
        return distanceValue
    }
    public typealias DateUnitRange = (begin: Date, length: TimeInterval)
    /// Calculate begin date and interval in date unit of self
    ///
    /// - Parameters:
    ///   - unit: date unit
    ///   - calendar: default current
    /// - Returns: Tuple contains begin date and interval
    public func range(_ unit: Calendar.Component, in calendar: Calendar = .current) -> DateUnitRange {
 
//        var component: Calendar.Component
//        switch unit {
//        case .second:
//            component = .second
//        case .minute:
//            component = .minute
//        case .hour:
//            component = .hour
//        case .day:
//            component = .day
//        case .month:
//            component = .month
//        case .year:
//            component = .year
//        case .week:
//            //周日是第一天
//            component = .weekOfYear
//        case .timeZone:
//            component = .timeZone
//        }
        var startDate: Date = Date.init()
        var interval: TimeInterval = 0
        let success = calendar.dateInterval(of: unit, start: &startDate, interval: &interval, for: self)
        if !success {
            var components = calendar.dateComponents(Date.commentFlags, from: self)
            var endComponents = components
            // swiftlint:disable fallthrough
            switch unit {
            case .year:
                components.month = 1
                endComponents.month = 12
                fallthrough
            case .month:
                components.day = 1
                endComponents.day = daysInMonth(endComponents.year!, at: endComponents.month!)
                fallthrough
            case .weekday:
                fallthrough
            case .day:
                components.hour = 0
                endComponents.hour = 23
                fallthrough
            case .hour:
                components.minute = 0
                endComponents.minute = 59
                fallthrough
            case .minute:
                components.second = 0
                endComponents.second = 59
                fallthrough
            default:
                break
            }
            // swiftlint:enable fallthrough
            startDate = calendar.date(from: components)!
            var endDate = calendar.date(from: endComponents)!
            if unit == .weekday {
                let weekDay = components.weekday!
                startDate -= TimeInterval(weekDay) * oneDaySeconds
                endDate += TimeInterval(7 - weekDay) * oneDaySeconds
            }
            interval = endDate.timeIntervalSince(startDate)
        }
        return (begin:startDate, length:interval)
    }
    /// min seconds in date unit
    ///
    /// - Returns: min date in unit
    public func dateStart(_ unit: Calendar.Component, in calendar: Calendar = .current) -> Date {
        return range(unit, in: calendar).begin
    }
    /// max seconds in date unit
    ///
    /// - Returns: max date in unit
    public func dateEnd(_ unit: Calendar.Component, in calendar: Calendar = .current) -> Date {
        let dateUnit = range(unit, in: calendar)
        return dateUnit.begin + TimeInterval(dateUnit.length-1)
    }
    /// forward a date unit time
    ///
    /// - Returns: before time min date
    public func beforeDate(_ unit: Calendar.Component, in calendar: Calendar = .current) -> Date {
        let beforeDate = dateStart(unit, in: calendar)
        let interval = beforeDate.addingTimeInterval(-1).range(unit, in: calendar).length
        return beforeDate - interval
    }
    /// behind a date unit time
    ///
    /// - Returns: after time min date
    public func nextDate(_ unit: Calendar.Component, in calendar: Calendar = .current) -> Date {
        return dateEnd(unit, in: calendar) + 1
    }
    public func daysInMonth(_ year: Int, at month: Int) -> Int {
        var days: Int = 30
        if month == 2 {
            if  year % 4 == 0 {
                days = 28
            } else {
                days = 29
            }
        } else if month == 4 || month == 6
            || month == 9 || month == 11 {
            days = 30
        } else {
            days = 31
        }
        return days
    }
    public func daysInYear(_ year: Int, at month: Int) -> Int {
        var days: Int = 30
        if month == 2 {
            if  year % 4 == 0 {
                days = 28
            } else {
                days = 29
            }
        } else if month == 4 || month == 6
            || month == 9 || month == 11 {
            days = 30
        } else {
            days = 31
        }
        return days
    }
    /// Calculate the date in unit
    ///
    /// - Parameters:
    ///   - counts: calculate count , may be negative
    ///   - unit: unit of measurement
    ///   - calendar:default current
    /// - Returns: calculated date
    public func dateByAdding(_ counts: Int, unit: Calendar.Component, in calendar: Calendar = .current) -> Date {
        var components = DateComponents()
        switch unit {
        case .second:
            components.second = counts
        case .minute:
            components.minute = counts
        case .hour:
            components.hour = counts
        case .weekOfYear:
            components.weekOfYear = counts
        case .day:
            components.day = counts
        case .month:
            components.month = counts
        case .year:
            components.year = counts
        default:
            break
        }
        return calendar.date(byAdding: components, to: self)!
    }
}

// MARK: - Compare
extension Date {
    
    public func isToday(in calendar: Calendar = .current) -> Bool {
        return calendar.isDateInToday(self)
//        return isSame(Date(),at: .day , in: calendar)
    }
    public func isYesterday(in calendar: Calendar = .current) -> Bool {
        return calendar.isDateInYesterday(self)
    }
    public func isTomorrow(in calendar: Calendar = .current) -> Bool {
        return calendar.isDateInTomorrow(self)
    }
    
    public func isThisWeek(in calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
//        return isSame(Date() ,at: .weekOfYear , in: calendar)
    }
    public func isNextWeek(in calendar: Calendar = .current) -> Bool {
         return calendar.isDate(self, equalTo: Date() + oneWeekSeconds, toGranularity: .weekOfYear)
//        return isSame(Date() + oneWeekSeconds ,at: .weekOfYear , in: calendar)
    }
    public func isLastWeek(in calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date() - oneWeekSeconds, toGranularity: .weekOfYear)
//        return isSame(Date() - oneWeekSeconds ,at: .weekOfYear , in: calendar)
    }
    
    public func isThisMonth(in calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .month)
//        return isSame(Date() ,at: .month , in: calendar)
    }
    public func isNextMonth(in calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date().dateByAdding(1, unit: .month, in: calendar), toGranularity: .month)
//        return isSame(Date().dateByAdding(1, unit: .month, in: calendar) ,at: .month , in: calendar)
    }
    public func isLastMonth(in calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self,
                               equalTo: Date().dateByAdding(-1, unit: .month, in: calendar),
                               toGranularity: .month)
//        return isSame(Date().dateByAdding(-1, unit: .month, in: calendar)  ,at: .month , in: calendar)
    }
    
    public func isThisYear(in calendar: Calendar = .current) -> Bool {
         return calendar.isDate(self, equalTo: Date(), toGranularity: .year)
//        return isSame(Date() ,at: .year , in: calendar)
    }
    public func isNextYear(in calendar: Calendar = .current) -> Bool {
         return calendar.isDate(self, equalTo: Date().dateByAdding(1, unit: .year, in: calendar), toGranularity: .month)
//        return isSame(Date().dateByAdding(1, unit: .year, in: calendar) ,at: .year , in: calendar)
    }
    public func isLastYear(in calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date().dateByAdding(-1, unit: .year, in: calendar), toGranularity: .month)
//        return isSame(Date().dateByAdding(-1, unit: .year, in: calendar)  ,at: .year , in: calendar)
    }
    
    public static let commentFlags: Set<Calendar.Component> = [
        .second,
        .minute,
        .hour,
        .day,
        .month,
        .year,
        .weekOfYear,
        .weekday,
        .timeZone
    ]

    /// judge date is same in DateUnit
    ///
    /// - Parameters:
    ///   - other: another date
    ///   - unit: compare unit
    ///   - calendar: what calendar compare
    /// - Returns: results
//    public func isSame(_ other:Date, at unit:Calendar.Component, in calendar:Calendar = .current) -> Bool{
//        let components = calendar.dateComponents(Date.commentFlags, from: self)
//        let compareComponents = calendar.dateComponents(Date.commentFlags, from: other)
//        var isSame = true
//        switch unit {
//            case .second:
//                if components.second! == compareComponents.second! {
//                    fallthrough
//                }else{
//                    isSame = false
//                }
//            case .minute:
//                if components.minute! == compareComponents.minute! {
//                    fallthrough
//                }else{
//                    isSame = false
//                }
//            case .hour:
//                if components.hour! == compareComponents.hour! {
//                    fallthrough
//                }else{
//                    isSame = false
//                }
//            case .day:
//                if components.day! == compareComponents.day! {
//                    fallthrough
//                }else{
//                    isSame = false
//                }
//            case .month:
//                if components.month! == compareComponents.month! {
//                    fallthrough
//                }else{
//                    isSame = false
//                }
//            case .year:
//                if components.year! != compareComponents.year! {
//                     isSame = false
//                }
//            case .weekOfYear:
//                if components.year! != compareComponents.year!||components.weekOfYear! != compareComponents.weekOfYear!{
//                    isSame = false
//                }
//            case .timeZone:
//                if (components.timeZone! != compareComponents.timeZone!) {
//                    isSame = false
//                }
//            default:
//                isSame = false
//        }
//        return isSame
//
//    }
  
}
