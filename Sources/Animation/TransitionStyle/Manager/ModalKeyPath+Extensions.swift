//
//  TransitionItem+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/12.
//

import Foundation
public typealias ModalTargets = [ModalTargetItem]

public extension ModalTargets {
    mutating func addState(_ target: NSObject?, _ values: [ModalKeyPath]) {
        if let targetItem = self.first(where: {$0.target === target }) {
            targetItem.refrences.append(contentsOf: values)
        } else if let root = target {
            let item = ModalTargetItem(root, refrences: values)
            self.append(item)
        
        }
    }
    
    mutating func addState(_ target: NSObject, _ value: ModalKeyPath) {
        self.addState(target, [value])
    }
    
    mutating func merge(_ refrence: ModalTargets) {
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

extension Dictionary where Key == ModalState, Value == [ModalKeyPath] {
    
    mutating func combine(_ values: [ModalState: ModalKeyPath]) {
        for state in ModalState.allCases {
            var value = self[state] ?? []
            if let refrence = values[state] {
                value.append(refrence)
            }
            self[state] = value
        }
    }
}
extension Dictionary where Key == ModalState, Value == [ModalTargetItem] {
    mutating func append(_ target: NSObject, with state: ModalState, refrences: [ModalKeyPath]) {
        let item = ModalTargetItem(target, refrences: refrences)
        var items = self[state] ?? []
        items.append(item)
        self[state] = items
    }
    mutating func combine(_ values: [ModalState: ModalTargetItem]) {
        for state in ModalState.allCases {
            var value = self[state] ?? []
            if let refrence = values[state] {
                value.append(refrence)
            }
            self[state] = value
        }
    }
}
