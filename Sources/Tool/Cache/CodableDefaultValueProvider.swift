//
//  CodableDefaultValueProvider.swift
//  Pods
//
//  Created by WQ on 2020/11/12.
//

import Foundation
#if swift(>=5.1)
public extension Int {
    enum Zero: CodableDefaultValue {
        public static let defaultValue = 0
    }
    enum One: CodableDefaultValue {
        public static let defaultValue = 1
    }
    enum Two: CodableDefaultValue {
        public static let defaultValue = 2
    }
    enum Three: CodableDefaultValue {
        public static let defaultValue = 3
    }
    enum NotFound: CodableDefaultValue {
        public static let defaultValue = NSNotFound
    }
}
public extension Double {
    enum Zero: CodableDefaultValue {
        public static let defaultValue = 0
    }
    enum One: CodableDefaultValue {
        public static let defaultValue = 1
    }
    enum Two: CodableDefaultValue {
        public static let defaultValue = 2
    }
    enum Three: CodableDefaultValue {
        public static let defaultValue = 3
    }
}
public extension String {
    enum Empty: CodableDefaultValue {
        public static let defaultValue = "" 
    }
}
public extension Bool {
    enum False: CodableDefaultValue {
        public static let defaultValue = false
    }
    enum True: CodableDefaultValue {
        public static let defaultValue = true
    }
}

public extension CodableDefault {
    // Bool
    typealias True = CodableDefault<Bool.True>
    typealias False = CodableDefault<Bool.False>
    
    // Int
    typealias IntZero = CodableDefault<Int.Zero>
    typealias IntOne = CodableDefault<Int.One>
    typealias IntTwo = CodableDefault<Int.Two>
    typealias IntThree = CodableDefault<Int.Three>
    typealias NotFound = CodableDefault<Int.NotFound>
    // Double
    typealias DoubleZero = CodableDefault<Int.Zero>
    typealias DoubleOne = CodableDefault<Int.One>
    typealias DoubleTwo = CodableDefault<Int.Two>
    typealias DoubleThree = CodableDefault<Int.Three>
    // String
    typealias Empty = CodableDefault<String.Empty>
}
#endif
