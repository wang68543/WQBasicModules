//
//  UserDefaults+Wrapper.swift
//  Pods
//
//  Created by WQ on 2020/11/11.
//

import Foundation
// import SwifterSwift
#if swift(>=5.1)
@propertyWrapper
public struct UserDefault<T> {
    private typealias FunGetter = () -> T
    private typealias FunSetter = (T) -> Void

    private let getter: FunGetter
    private let setter: FunSetter

    private init(_ getter: @escaping FunGetter, setter: @escaping FunSetter) {
        self.getter = getter
        self.setter = setter
    }
    public var wrappedValue: T {
        get { return self.getter() }
        set { self.setter(newValue) }
    }
}
public extension UserDefault where T: Codable {
    init(_ key: String, default value: T, standard: UserDefaults = .standard) {
        let setter: FunSetter = { standard.set(object: $0, forKey: key) }
        let getter: FunGetter = { standard.object(key) ?? value }
        self.init(getter, setter: setter)
    }
}

public extension UserDefault where T == Date {
    init(_ key: String, default value: T = Date(), standard: UserDefaults = .standard) {
        let setter: FunSetter = { standard.set($0, forKey: key) }
        let getter: FunGetter = { standard.date(forKey: key) ?? value }
        self.init(getter, setter: setter)
    }
}
public extension UserDefault where T == String {
    init(_ key: String, default value: T = "", standard: UserDefaults = .standard) {
        let setter: FunSetter = { standard.set($0, forKey: key) }
        let getter: FunGetter = { standard.string(forKey: key) ?? value }
        self.init(getter, setter: setter)
    }
}
public extension UserDefault where T == Data? {
    init(_ key: String, standard: UserDefaults = .standard) {
        let setter: FunSetter = { standard.set($0, forKey: key) }
        let getter: FunGetter = {
            let data = standard.data(forKey: key)
            if data == nil || data == UserDefaults.nullValue {
                return nil
            }
            return data
        }
        self.init(getter, setter: setter)
    }
}
public extension UserDefault where T == Int {
    init(_ key: String, standard: UserDefaults = .standard) {
        let setter: FunSetter = { standard.set($0, forKey: key) }
        let getter: FunGetter = { standard.integer(forKey: key) }
        self.init(getter, setter: setter)
    }
}
public extension UserDefault where T == Int64 {
    init(_ key: String, standard: UserDefaults = .standard) {
        let setter: FunSetter = { standard.set($0, forKey: key) }
        let getter: FunGetter = { Int64(standard.integer(forKey: key)) }
        self.init(getter, setter: setter)
    }
}
public extension UserDefault where T == Double {
    init(_ key: String, standard: UserDefaults = .standard) {
        let setter: FunSetter = { standard.set($0, forKey: key) }
        let getter: FunGetter = { standard.double(forKey: key) }
        self.init(getter, setter: setter)
    }
}
public extension UserDefault where T == CGFloat {
    init(_ key: String, standard: UserDefaults = .standard) {
        let setter: FunSetter = { standard.set($0, forKey: key) }
        let getter: FunGetter = { CGFloat(standard.double(forKey: key)) }
        self.init(getter, setter: setter)
    }
}
public extension UserDefault where T == Bool {
    init(_ key: String, standard: UserDefaults = .standard) {
        let setter: FunSetter = { standard.set($0, forKey: key) }
        let getter: FunGetter = { standard.bool(forKey: key) }
        self.init(getter, setter: setter)
    }
}
#endif
