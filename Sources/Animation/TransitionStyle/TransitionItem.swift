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
 
//public extension NSObjectProtocol where Self: NSObject {
//
//}
 
public protocol TSReferenceWriteable {
    func setup(_ target: Any)
}
 
public class TSReference<Root, Value>: TSReferenceWriteable {
   public private(set) var value: Value
    public let keyPath: ReferenceWritableKeyPath<Root, Value>
    init(value: Value, keyPath: ReferenceWritableKeyPath<Root, Value>) {
       self.value = value
       self.keyPath = keyPath
   }
   public func setup(_ target: Any) {
     guard let item = target as? Root else { return }
     item[keyPath: keyPath] = value
   }
   
}
//func setter<Object: AnyObject, Value>(
//    for object: Object,
//    keyPath: ReferenceWritableKeyPath<Object, Value>
//) -> (Value) -> Void {
//    return { [weak object] value in
//        object?[keyPath: keyPath] = value
//    }
//}
//@dynamicMemberLookup
public class TSRectRefrence<Root>: TSReference<Root,CGRect> {
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<CGRect, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
@dynamicMemberLookup
public class TSMutableTransformRefrence: TSReference<CGAffineTransform> {
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<CGAffineTransform, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
@dynamicMemberLookup
public class TSMutableColorRefrence: TSReference<UIColor> {
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<UIColor, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}

//func addTarget<Value>(_ target: UIViewController, value: TSReference<Value>) {
//
//}
///// 转场的状态
//public enum TransitionState {
//    /// 准备显示之前状态
//    case readyShow
//    /// 显示
//    case show
//    ///
//    case hide
//}


