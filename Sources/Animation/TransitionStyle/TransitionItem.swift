//
//  TransitionItem.swift
//  Pods-WQBasicModules_Example
//
//  Created by iMacHuaSheng on 2020/8/10.
//

import Foundation
//public protocol TransitionItem {
//    associatedtype T
//    var keyPath: PartialKeyPath
//}
 

@dynamicMemberLookup
public class TSReference<Value> {
    public private(set) var value: Value
    init(value: Value) {
        self.value = value
    }
    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }
}
@dynamicMemberLookup
public class TSMutableReference<Value>: TSReference<Value> {
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
@dynamicMemberLookup
public class TSMutableRectRefrence: TSReference<CGRect> {
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<CGRect, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
@dynamicMemberLookup
public class TSMutableAffineTransformRefrence: TSReference<CGAffineTransform> {
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<CGAffineTransform, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
@dynamicMemberLookup
public class TSMutableColorformRefrence: TSReference<UIColor> {
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<UIColor, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
/// 转场的状态
public enum TransitionState {
    /// 准备显示之前状态
    case readyShow
    /// 显示
    case show
    ///
    case hide
}


