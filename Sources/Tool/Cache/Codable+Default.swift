//
//  Codable+Default.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/11.
//

import Foundation
#if swift(>=5.1)
//https://mp.weixin.qq.com/s/jOyHRS2Wx6MJpuYuENhVgg
public protocol CodableDefaultValue {
    associatedtype Value: Codable
    static var defaultValue: Value { get }
} 
 
@propertyWrapper
public struct CodableDefault<T: CodableDefaultValue> {
    public var wrappedValue: T.Value
    public init(wrappedValue: T.Value) {
        self.wrappedValue = wrappedValue
    }
}

extension CodableDefault: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
public extension KeyedDecodingContainer {
    func decode<T>(
        _ type: CodableDefault<T>.Type,
        forKey key: Key
    ) throws -> CodableDefault<T> where T: CodableDefaultValue {
        try decodeIfPresent(type, forKey: key) ?? CodableDefault(wrappedValue: T.defaultValue)
    }
}
public extension KeyedEncodingContainer {
    mutating func encode<T>(_ value: CodableDefault<T>, forKey key: Key) throws where T: CodableDefaultValue {
        try encode(value.wrappedValue, forKey: key)
    }
}
#endif
