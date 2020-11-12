//
//  TransitionItem+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/12.
//

import Foundation
public typealias WQReferenceStates = [TSReferenceTargetItem]

public extension WQReferenceStates {
    mutating func addState(_ target: NSObject?, _ values: [TSReferenceWriteable]) {
        if let targetItem = self.first(where: {$0.target === target }) {
            targetItem.refrences.append(contentsOf: values)
        } else if let root = target {
            let item = TSReferenceTargetItem(root, refrences: values)
            self.append(item)
        
        }
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
        }
    }
}

extension Dictionary where Key == ModalState, Value == [TSReferenceWriteable] {
    mutating func combine(_ values: [ModalState: TSReferenceWriteable]) {
        for state in ModalState.allCases {
            var value = self[state] ?? []
            if let refrence = values[state] {
                value.append(refrence)
            }
            self[state] = value
        }
    }
}
extension Dictionary where Key == ModalState, Value == [TSReferenceTargetItem] {
    mutating func combine(_ values: [ModalState: TSReferenceTargetItem]) {
        for state in ModalState.allCases {
            var value = self[state] ?? []
            if let refrence = values[state] {
                value.append(refrence)
            }
            self[state] = value
        }
    }
}
