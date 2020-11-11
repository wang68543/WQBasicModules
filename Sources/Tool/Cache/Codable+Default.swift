//
//  Codable+Default.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/11.
//

import Foundation
#if swift(>=5.1)
//https://mp.weixin.qq.com/s/jOyHRS2Wx6MJpuYuENhVgg
public protocol DefaultValue {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

extension Bool: DefaultValue {
    public static let defaultValue = false
}
 
@propertyWrapper
public struct Default<T: DefaultValue> {
    public var wrappedValue: T.Value
    public init(wrappedValue: T.Value) {
        self.wrappedValue = wrappedValue
    }
}

extension Default: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
}
public extension KeyedDecodingContainer {
    func decode<T>(
        _ type: Default<T>.Type,
        forKey key: Key
    ) throws -> Default<T> where T: DefaultValue {
        try decodeIfPresent(type, forKey: key) ?? Default(wrappedValue: T.defaultValue)
    }
}
public extension Bool {
    enum False: DefaultValue {
        public static let defaultValue = false
    }
    enum True: DefaultValue {
        public static let defaultValue = true
    }
} 
public extension Default {
    typealias True = Default<Bool.True>
    typealias False = Default<Bool.False>
}
#endif
