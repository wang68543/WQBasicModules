//
//  TransitionItem.swift
//  Pods-WQBasicModules_Example
//
//  Created by iMacHuaSheng on 2020/8/10.
//

import Foundation
 
public protocol TSReferenceWriteable {
    func setup(_ target: Any, state: ModalState)
}
public class TSReference<Root, Value>: TSReferenceWriteable { 
    
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
/// 解决循环引用问题
public class TSReferenceTargetItem {
    weak var target: NSObject?
    var refrences: [TSReferenceWriteable]
    init(_ target: NSObject, refrences: [TSReferenceWriteable]) {
        self.target = target
        self.refrences = refrences
    }
    func setup(for state: ModalState) {
        guard let root = target else { return }
        refrences.forEach({ $0.setup(root, state: state)})
    }
}

 


public class TSReferenceRect: TSReference<WQLayoutController, CGRect> { }
public class TSReferenceColor: TSReference<WQLayoutController, UIColor> { }
public class TSReferenceTransform: TSReference<WQLayoutController, CGAffineTransform> { }
public class TSReferencePosition: TSReference<WQLayoutController, CGPoint> { }
public class TSReferenceToggle: TSReference<WQLayoutController, Bool> { }
public class TSReferenceValue: TSReference<WQLayoutController, CGFloat> { }
 
public extension TSReferenceTransform {
    convenience init(container value: CGAffineTransform) {
        self.init(value, keyPath: \WQLayoutController.container.transform)
    }
}
public extension TSReferenceValue {
    /// alapha
    convenience init(container value: CGFloat) {
        self.init(value, keyPath: \WQLayoutController.container.alpha)
    }
    convenience init(dimming value: CGFloat) {
        self.init(value, keyPath: \WQLayoutController.dimmingView.alpha)
    }
}
public extension TSReferenceRect {
    convenience init(container value: CGRect) {
        self.init(value, keyPath: \WQLayoutController.container.frame)
    }
}
