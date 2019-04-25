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

public extension Date {// MARK: - Components
    func year(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.year], from: self).year!
    }
    func month(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.month], from: self).month!
    }
    func day(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.day], from: self).day!
    }
    func hour(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.hour], from: self).hour!
    }
    func minute(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.minute], from: self).minute!
    }
    func second(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.second], from: self).second!
    }
    func weekday(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.weekday], from: self).weekday!
    }
    func weekOfYear(_ calendar: Calendar = .current) -> Int {
        return calendar.dateComponents([.weekOfYear], from: self).weekOfYear!
    }
    func timeZone(_ calendar: Calendar = .current) -> TimeZone {
        return calendar.dateComponents([.timeZone], from: self).timeZone!
    }
}
// MARK: - Calculate
public extension Date {
    /// calculate date 根据一年的第几周推算出这周的起始日期
    ///
    /// - Parameters:
    ///   - week: ordinality of week in year
    ///   - weekDay: day of the week (1~7 从周日开始)
    ///   - year: in year
    ///   - calendar: caculate calendar
    /// - Returns: the first day in week (Sun)
    static func date(of week: Int, in year: Int, with calendar: Calendar = .current) -> Date? {
        let  dateComponments = DateComponents(year: year, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)
        let yearStartDate = calendar.date(from: dateComponments)
        guard let startDate = yearStartDate else {
            return nil
        }
        let component = calendar.component(.weekday, from: startDate)
        let interval = (week - 1) * 7 - (component - 1)
        return calendar.date(byAdding: .day, value: interval, to: startDate)
    }
    
    /// distance unit counts between two date
    ///
    /// - Parameters:
    ///   - endDate: another date
    ///   - unit: calculation calendar  unit
    ///   - calendar: calendar
    /// - Returns: distance
    func distance(_ endDate: Date,
                  at unit: Calendar.Component = .day,
                  with calendar: Calendar = .current) -> Int {
        var startComp = calendar.dateComponents(Date.commentFlags, from: self)
        var endComp = calendar.dateComponents(Date.commentFlags, from: endDate)
        // swiftlint:disable fallthrough
        switch unit {
        case .era:
            startComp.year = 0
            endComp.year = 0
            fallthrough
        case .year:
            startComp.month = 1
            endComp.month = 1
            fallthrough
        case .month:
            startComp.day = 1
            endComp.day = 1
            fallthrough
        case .day:
            startComp.hour = 0
            endComp.hour = 0
            fallthrough
        case .hour:
            startComp.minute = 0
            endComp.minute = 0
            fallthrough
        case .minute:
            startComp.second = 0
            endComp.second = 0
            fallthrough
        case .second:
            startComp.nanosecond = 0
            endComp.nanosecond = 0
            fallthrough
        default:
            break
        }
        let deltComponments = calendar.dateComponents([unit], from: startComp, to: endComp)
       
        guard let value = deltComponments.value(for: unit) else {
            return 0
        }
        return value
    }
    typealias DateUnitRange = (begin: Date, length: TimeInterval)
    /// Calculate begin date and interval in date unit of self
    ///
    /// - Parameters:
    ///   - unit: date unit
    ///   - calendar: default current
    /// - Returns: Tuple contains begin date and interval
    func range(_ unit: Calendar.Component,
               with calendar: Calendar = .current) -> DateUnitRange {
        var startDate: Date = self
        var interval: TimeInterval = 0
        var success = false
        if #available(iOS 10.0, *) {
            if let dateInterval = calendar.dateInterval(of: unit, for: self) {
                startDate = dateInterval.start
                interval = dateInterval.duration
                success = true
            }
        } else {
            success = calendar.dateInterval(of: unit, start: &startDate, interval: &interval, for: self)
        }
        if !success {
            var components = calendar.dateComponents(Date.commentFlags, from: self)
            var endComponents = components
            // swiftlint:disable fallthrough
            switch unit {
            case .year:
                components.month = 1; endComponents.month = 12
                fallthrough
            case .month:
                let days = daysInMonth(endComponents.year!, at: endComponents.month!)
                components.day = 1; endComponents.day = days
                fallthrough
            case .day, .weekday:
                components.hour = 0; endComponents.hour = 23
                fallthrough
            case .hour:
                components.minute = 0; endComponents.minute = 59
                fallthrough
            case .minute:
                components.second = 0; endComponents.second = 59
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
    func dateStart(_ unit: Calendar.Component, with calendar: Calendar = .current) -> Date {
        return range(unit, with: calendar).begin
    }
    /// max seconds in date unit
    ///
    /// - Returns: max date in unit
    func dateEnd(_ unit: Calendar.Component, with calendar: Calendar = .current) -> Date {
        let dateUnit = range(unit, with: calendar)
        return dateUnit.begin + TimeInterval(dateUnit.length - 1)
    }
    /// forward a date unit time
    ///
    /// - Returns: before time min date
    func beforeDate(_ unit: Calendar.Component, with calendar: Calendar = .current) -> Date {
        let beforeDate = dateStart(unit, with: calendar)
        let interval = beforeDate.addingTimeInterval(-1).range(unit, with: calendar).length
        return beforeDate - interval
    }
    /// behind a date unit time
    ///
    /// - Returns: after time min date
    func nextDate(_ unit: Calendar.Component, with calendar: Calendar = .current) -> Date {
        return dateEnd(unit, with: calendar) + 1
    }
    
    /// smaller unit counts in larger unit
    ///
    /// - Parameters:
    ///   - unit: smaller unit
    func counts(_ unit: Calendar.Component, in larger: Calendar.Component = .nanosecond, with calendar: Calendar = .current) -> Int {
        var bigUnit: Calendar.Component
        if larger == .nanosecond {
            switch unit {
            case .second:
                bigUnit = .minute
            case .minute:
                bigUnit = .hour
            case .hour:
                bigUnit = .day
            case .day, .weekOfMonth: 
                bigUnit = .month
            case .month, .weekOfYear:
                bigUnit = .year
                
            default:
                fatalError("此类型的单位计算不支持")
            }
        } else {
            bigUnit = larger
        }
        
        guard let counts = calendar.range(of: unit, in: bigUnit, for: self) else {
            return 0
        }
        return counts.upperBound - counts.lowerBound
    }
    
    func daysInMonth(_ year: Int, at month: Int) -> Int {
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
    func daysInYear(_ year: Int, at month: Int) -> Int {
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
    func dateByAdding(_ counts: Int, unit: Calendar.Component, with calendar: Calendar = .current) -> Date {
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
public extension Date {// MARK: - Compare
    
    func isToday(with calendar: Calendar = .current) -> Bool {
        return calendar.isDateInToday(self)
    }
    func isYesterday(with calendar: Calendar = .current) -> Bool {
        return calendar.isDateInYesterday(self)
    }
    func isTomorrow(with calendar: Calendar = .current) -> Bool {
        return calendar.isDateInTomorrow(self)
    }
    
    func isThisWeek(with calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    func isNextWeek(with calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date() + oneWeekSeconds, toGranularity: .weekOfYear)
    }
    func isLastWeek(with calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date() - oneWeekSeconds, toGranularity: .weekOfYear)
    }
    func isThisMonth(with calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    func isNextMonth(with calendar: Calendar = .current) -> Bool {
        let nextDate = Date().dateByAdding(1, unit: .month, with: calendar)
        return calendar.isDate(self, equalTo: nextDate, toGranularity: .month)
    }
    func isLastMonth(with calendar: Calendar = .current) -> Bool {
        let nextDate = Date().dateByAdding(-1, unit: .month, with: calendar)
        return calendar.isDate(self, equalTo: nextDate, toGranularity: .month)
    }
    func isThisYear(with calendar: Calendar = .current) -> Bool {
         return calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    func isNextYear(with calendar: Calendar = .current) -> Bool {
        let nextDate = Date().dateByAdding(1, unit: .year, with: calendar)
        
         return calendar.isDate(self, equalTo: nextDate, toGranularity: .month)
    }
    func isLastYear(with calendar: Calendar = .current) -> Bool {
        let nextDate = Date().dateByAdding(-1, unit: .year, with: calendar)
        return calendar.isDate(self, equalTo: nextDate, toGranularity: .month)
    }
    
   private static let commentFlags: Set<Calendar.Component> = [
        .second,
        .minute,
        .hour,
        .day,
        .month,
        .year,
        .weekOfYear,
        .weekday,
        .timeZone]
  
}

// MARK: - --equal
public extension Date {
    //swiftlint:disable function_body_length
    func isSame(_ otherDate: Date, unit: Calendar.Component = .day, calendar: Calendar = Calendar.current) -> Bool {
        let cmps = calendar.dateComponents(in: calendar.timeZone, from: self)
        let otherCmps = calendar.dateComponents(in: calendar.timeZone, from: otherDate)
        var isSame: Bool = true
        switch unit {
        case .nanosecond:
            if cmps.nanosecond != otherCmps.nanosecond { return false }
            fallthrough
        case .second:
            if cmps.second != otherCmps.second { return false }
            fallthrough
        case .minute:
            if cmps.minute != otherCmps.minute { return false }
            fallthrough
        case .hour:
            if cmps.hour != otherCmps.hour { return false }
            fallthrough
        case .day:
            if cmps.day != otherCmps.day { return false }
            fallthrough
        case .month:
            if cmps.month != otherCmps.month { return false }
            fallthrough
        case .year:
            if cmps.year != otherCmps.year { return false }
            fallthrough
        case .era:
            isSame = cmps.era == otherCmps.era
        case .weekday:
            isSame = cmps.weekday == otherCmps.weekday
                    && self.isSame(otherDate, unit: .day, calendar: calendar)
        case .weekdayOrdinal:
            isSame = cmps.weekdayOrdinal == otherCmps.weekdayOrdinal
                    && self.isSame(otherDate, unit: .day, calendar: calendar)
        case .quarter:
            isSame = cmps.quarter == otherCmps.quarter
                    && self.isSame(otherDate, unit: .day, calendar: calendar)
        case .weekOfMonth:
            isSame = cmps.weekOfMonth == otherCmps.weekOfMonth
                    && self.isSame(otherDate, unit: .month, calendar: calendar)
        case .weekOfYear:
            isSame = cmps.weekOfYear == otherCmps.weekOfYear
                    && self.isSame(otherDate, unit: .year, calendar: calendar)
        case .yearForWeekOfYear:
            isSame = cmps.yearForWeekOfYear == otherCmps.yearForWeekOfYear
                    && self.isSame(otherDate, unit: .year, calendar: calendar)
        default:
            isSame = false
        }
        return isSame
    }
}
