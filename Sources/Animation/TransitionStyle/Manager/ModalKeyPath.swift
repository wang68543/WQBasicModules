//
//  TransitionItem.swift
//  Pods-WQBasicModules_Example
//
//  Created by iMacHuaSheng on 2020/8/10.
//

import Foundation
 
public protocol ModalKeyPath {
    func setup(_ target: Any, state: ModalState)
}
public class ModalReference<Root, Value>: ModalKeyPath { 
    
    public let value: Value
    public let keyPath: ReferenceWritableKeyPath<Root, Value>
    public init(_ value: Value, keyPath: ReferenceWritableKeyPath<Root, Value>) {
       self.value = value
       self.keyPath = keyPath
   }
    public func setup(_ target: Any, state: ModalState) {
     guard let item = target as? Root else { return }
     item[keyPath: keyPath] = value
   } 
} 
@available(iOS 10.0, *)
public class ModalRect: ModalReference<WQLayoutController, CGRect> { }
@available(iOS 10.0, *)
public class ModalColor: ModalReference<WQLayoutController, UIColor> { }
@available(iOS 10.0, *)
public class ModalTransform: ModalReference<WQLayoutController, CGAffineTransform> { }
@available(iOS 10.0, *)
public class ModalPosition: ModalReference<WQLayoutController, CGPoint> { }
@available(iOS 10.0, *)
public class ModalBool: ModalReference<WQLayoutController, Bool> { }
@available(iOS 10.0, *)
public class ModalFloat: ModalReference<WQLayoutController, CGFloat> { }


@available(iOS 10.0, *)
public extension ModalTransform {
    convenience init(container value: CGAffineTransform) {
        self.init(value, keyPath: \WQLayoutController.container.transform)
    }
}

@available(iOS 10.0, *)
public extension ModalFloat {
    /// alapha
    convenience init(container value: CGFloat) {
        self.init(value, keyPath: \WQLayoutController.container.alpha)
    }
    convenience init(dimming value: CGFloat) {
        self.init(value, keyPath: \WQLayoutController.dimmingView.alpha)
    }
}

@available(iOS 10.0, *)
public extension ModalRect {
    convenience init(container value: CGRect) {
        self.init(value, keyPath: \WQLayoutController.container.frame)
    }
}
