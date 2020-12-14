//
//  UtilitesCompare.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/10/21.
//

import Foundation

/// 精确判断(不是非此即彼)

/// 有值且为非0 为true
@inline(__always)
public func _isSuccess(_ flag: Int?) -> Bool { flag != 0 }
/// 有值且为0为true
@inline(__always)
public func _isFailure(_ flag: Int?) -> Bool { flag == 0 }

/// 有值且为非0 为true
@inline(__always)
public func _isSuccess(_ flag: Double?) -> Bool { flag != 0 }
/// 有值且为0为true
@inline(__always)
public func _isFailure(_ flag: Double?) -> Bool { flag == 0 }

/// 有值且为非0为true
@inline(__always)
public func _isSuccess(_ flag: String?) -> Bool {
    guard let str = flag else { return false }
    return str != "0"
}
/// 有值且为0为true
@inline(__always)
public func _isFailure(_ flag: String?) -> Bool {
    guard let str = flag else { return false }
    return str == "0"
}
