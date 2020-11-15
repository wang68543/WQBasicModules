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

public class ModalRect: ModalReference<WQLayoutController, CGRect> { }
public class ModalColor: ModalReference<WQLayoutController, UIColor> { }
public class ModalTransform: ModalReference<WQLayoutController, CGAffineTransform> { }
public class ModalPosition: ModalReference<WQLayoutController, CGPoint> { }
public class ModalBool: ModalReference<WQLayoutController, Bool> { }
public class ModalFloat: ModalReference<WQLayoutController, CGFloat> { }
 
public extension ModalTransform {
    convenience init(container value: CGAffineTransform) {
        self.init(value, keyPath: \WQLayoutController.container.transform)
    }
}
public extension ModalFloat {
    /// alapha
    convenience init(container value: CGFloat) {
        self.init(value, keyPath: \WQLayoutController.container.alpha)
    }
    convenience init(dimming value: CGFloat) {
        self.init(value, keyPath: \WQLayoutController.dimmingView.alpha)
    }
}
public extension ModalRect {
    convenience init(container value: CGRect) {
        self.init(value, keyPath: \WQLayoutController.container.frame)
    }
}
