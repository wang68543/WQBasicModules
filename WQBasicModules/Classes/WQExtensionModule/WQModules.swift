//
//  WQModules.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/26.
//

import Foundation
public final class WQModules<Base> {
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    } 
}
public protocol WQModulesCompatible {
    associatedtype WQModulesType
    // swiftlint:disable identifier_name
    var wm: WQModulesType { get }
}
public extension WQModulesCompatible {
    // swiftlint:disable identifier_name
    var wm: WQModules<Self> {
        return WQModules(self)
    }
}
extension UIView: WQModulesCompatible { }
