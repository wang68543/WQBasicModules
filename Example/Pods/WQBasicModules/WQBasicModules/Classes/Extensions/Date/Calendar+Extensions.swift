//
//  Calendar+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/6/21.
//

import Foundation
public extension Calendar {
    func numberOfDaysInMonth(for date: Date) -> Int {
        return range(of: .day, in: .month, for: date)!.count
    }
    func numberOfDaysInYear(for date: Date) -> Int {
        return range(of: .day, in: .year, for: date)!.count
    }
}
