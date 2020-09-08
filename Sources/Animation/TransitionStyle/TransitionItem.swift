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
    func setup(_ target: Any, state: ModalState)
}
 
public class TSReference<Root, Value>: TSReferenceWriteable {
    public let value: Value
    public let keyPath: ReferenceWritableKeyPath<Root, Value>
    public init(value: Value, keyPath: ReferenceWritableKeyPath<Root, Value>) {
       self.value = value
       self.keyPath = keyPath
   }
    public func setup(_ target: Any, state: ModalState) {
     guard let item = target as? Root else { return }
     item[keyPath: keyPath] = value
   }
   
}
public class TSReferenceRect: TSReference<WQLayoutController, CGRect> { }
public class TSReferenceColor: TSReference<WQLayoutController, UIColor> { }
public class TSReferenceTransform: TSReference<WQLayoutController, CGAffineTransform> { }
public class TSReferencePosition: TSReference<WQLayoutController, CGPoint> { }
public class TSReferenceToggle: TSReference<WQLayoutController, Bool> { }
public class TSReferenceValue: TSReference<WQLayoutController, CGFloat> { }
//@dynamicMemberLookup
//public class TSMutableTransformRefrence: TSReference<CGAffineTransform> {
//    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<CGAffineTransform, T>) -> T {
//        get { value[keyPath: keyPath] }
//        set { value[keyPath: keyPath] = newValue }
//    }
//}
//@dynamicMemberLookup
//public class TSMutableColorRefrence: TSReference<UIColor> {
//    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<UIColor, T>) -> T {
//        get { value[keyPath: keyPath] }
//        set { value[keyPath: keyPath] = newValue }
//    }
//}

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


