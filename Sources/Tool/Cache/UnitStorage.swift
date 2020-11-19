//
//  UnitStorage.swift
//  Pods
//
//  Created by 王强 on 2020/11/20.
//

import Foundation
@available(iOS 10.0, *)
open class UnitStorage: Dimension {
    /// B
    public static let bytes = UnitStorage(symbol: NSLocalizedString("B", comment: "UnitStorage"), converter: UnitConverterLinear(coefficient: 1))
    /// KB
    public static let kilobytes = UnitStorage(symbol: "K", converter: UnitConverterLinear(coefficient: 1024))
    /// MB
    public static let megabytes = UnitStorage(symbol: "M", converter: UnitConverterLinear(coefficient: 1024*1024))
    /// GB
    public static let gigabytes = UnitStorage(symbol: "G", converter: UnitConverterLinear(coefficient: 1024*1024*1024))
    /// TB
    public static let terabytes = UnitStorage(symbol: "T", converter: UnitConverterLinear(coefficient: 1024*1024*1024*1024))
    
    open override class func baseUnit() -> Self {
        return UnitStorage.bytes as! Self
    }
}
