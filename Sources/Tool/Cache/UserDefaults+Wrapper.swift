//
//  UserDefaults+Wrapper.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/11.
//

import Foundation
#if swift(>=5.1)

public protocol UserDefaulstValue {
    associatedtype Value: Codable
    static var userValue: Value { get }
}

extension Bool: UserDefaulstValue {
    public static let userValue = false
}
//public protocol UserDefaultable {
//    associatedtype T
//    func readValue() -> T?
//    func saveValue(_ newValue: T)
//}
@propertyWrapper
public struct UserDefault<T> {
    public let key: String
    public let standard: UserDefaults
    public init(_ key: String, standard: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.standard = standard
    }
    public var wrappedValue: T? {
        get {
            return readValue()
        }
        set {
            if let value = newValue {
                saveValue(value)
            } else {
                self.standard.removeObject(forKey: key)
            }
        }
    } 
}
public extension UserDefault {
    func saveValue(_ newValue: T) {
        fatalError("类型不匹配")
    }
    func readValue() -> T? {
        fatalError("类型不匹配")
    }
}
 
public extension UserDefault where T: Codable {
    func saveValue(_ newValue: T) {
        let data = try? newValue.data()
        self.standard.setValue(data, forKey: key)
    }
    func readValue() -> T? {
        guard let data = self.standard.value(forKey: key) as? Data else { return nil }
        return try? T.model(from: data)
    }
}
public extension UserDefault where T == Int {
    func saveValue(_ newValue: T) {
        self.standard.set(newValue, forKey: key)
    }
    func readValue() -> T? {
        return self.standard.integer(forKey: key)
    }
}
#endif
