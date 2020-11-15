//
//  TransitionItem+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/12.
//

import Foundation
public typealias ModalMapItems = [ModalMapItem]
/// 解决循环引用问题
public class ModalMapItem {
    weak var target: AnyObject?
    var refrences: [ModalKeyPath]
    init(_ target: AnyObject, refrences: [ModalKeyPath]) {
        self.target = target
        self.refrences = refrences
    }
    func setup(for state: ModalState) {
        guard let root = target else { return }
        refrences.forEach({ $0.setup(root, state: state)})
    }
}
public extension ModalMapItems {
    mutating func addState(_ target: AnyObject?, _ values: [ModalKeyPath]) {
        if let targetItem = self.first(where: {$0.target === target }) {
            targetItem.refrences.append(contentsOf: values)
        } else if let root = target {
            let item = ModalMapItem(root, refrences: values)
            self.append(item)
        }
    }
    
    mutating func addState(_ target: AnyObject, _ value: ModalKeyPath) {
        self.addState(target, [value])
    }
    
    mutating func merge(_ refrence: ModalMapItems) {
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
extension Dictionary where Key == ModalState, Value == [ModalMapItem] {
    mutating func append(_ target: AnyObject, with state: ModalState, refrences: [ModalKeyPath]) {
        let item = ModalMapItem(target, refrences: refrences)
        var items = self[state] ?? []
        items.append(item)
        self[state] = items
    }
    mutating func combine(_ values: [ModalState: ModalMapItem]) {
        for state in ModalState.allCases {
            var value = self[state] ?? []
            if let refrence = values[state] {
                value.append(refrence)
            }
            self[state] = value
        }
    }
}
