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
    public init(value: Value, keyPath: ReferenceWritableKeyPath<Root, Value>) {
       self.value = value
       self.keyPath = keyPath
   }
    public func setup(_ target: Any, state: ModalState) {
     guard let item = target as? Root else { return }
     item[keyPath: keyPath] = value
   } 
}
public typealias WQReferenceStates = [AnyHashable: [TSReferenceWriteable]]
public extension WQReferenceStates {
    func setup(for state: ModalState) {
        self.forEach { target, values in
            values.forEach({ $0.setup(target, state: state) })
        }
    }
}

public class TSReferenceRect: TSReference<WQLayoutController, CGRect> { }
public class TSReferenceColor: TSReference<WQLayoutController, UIColor> { }
public class TSReferenceTransform: TSReference<WQLayoutController, CGAffineTransform> { }
public class TSReferencePosition: TSReference<WQLayoutController, CGPoint> { }
public class TSReferenceToggle: TSReference<WQLayoutController, Bool> { }
public class TSReferenceValue: TSReference<WQLayoutController, CGFloat> { }
 
