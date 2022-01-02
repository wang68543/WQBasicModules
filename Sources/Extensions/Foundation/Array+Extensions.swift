//
//  Array+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/1/19.
//

import Foundation
public extension Array {
    var isNotEmpty: Bool { !isEmpty }

    mutating func sort<T: Comparable>(
      by keyPath: KeyPath<Element, T>,
      criteria: (T, T) -> Bool = { $0 < $1 }) {
      sort { a, b in
        criteria(a[keyPath: keyPath], b[keyPath: keyPath])
      }
    }

    func sorted<T: Comparable>(
      by keyPath: KeyPath<Element, T>,
      criteria: (T, T) -> Bool = { $0 < $1 }) -> [Element] {
      return sorted { a, b in
        criteria(a[keyPath: keyPath], b[keyPath: keyPath])
      }
    }
}
