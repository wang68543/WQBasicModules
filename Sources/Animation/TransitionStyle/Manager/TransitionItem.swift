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
public typealias WQReferenceStates = [TSReferenceTargetItem]
 
public extension WQReferenceStates {
    mutating func addState(_ target: NSObject?, _ values: [TSReferenceWriteable]) {
//        var item: TSReferenceTargetItem
        if let targetItem = self.first(where: {$0.target === target }) {
//            item = targetItem
            targetItem.refrences.append(contentsOf: values)
        } else if let root = target {
            let item = TSReferenceTargetItem(root, refrences: values)
            self.append(item)
        
        }
//        var states: [TSReferenceWriteable] = self[target] ?? []
//        states.append(contentsOf: values)
//        self[target] = states
    }
    
    mutating func addState(_ target: NSObject, _ value: TSReferenceWriteable) {
        self.addState(target, [value])
    }
    
    mutating func merge(_ refrence: WQReferenceStates) {
        for value in refrence {
            self.addState(value.target, value.refrences)
        }
    }
    
    func setup(for state: ModalState) {
        
        self.forEach { value in
            value.setup(for: state)
//            values.forEach({ $0.setup(target, state: state) })
        }
    }
}

public class TSReferenceRect: TSReference<WQLayoutController, CGRect> { }
public class TSReferenceColor: TSReference<WQLayoutController, UIColor> { }
public class TSReferenceTransform: TSReference<WQLayoutController, CGAffineTransform> { }
public class TSReferencePosition: TSReference<WQLayoutController, CGPoint> { }
public class TSReferenceToggle: TSReference<WQLayoutController, Bool> { }
public class TSReferenceValue: TSReference<WQLayoutController, CGFloat> { }
 
