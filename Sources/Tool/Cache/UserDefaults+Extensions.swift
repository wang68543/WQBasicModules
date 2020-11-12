//
//  UserDefaults+Extensions.swift
//  Pods
//
//  Created by WQ on 2019/6/21.
//

import Foundation
public extension UserDefaults {
    subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        set {
            set(newValue, forKey: key)
        }
    }
    /// Returns `true` if any value is associated with the given key, `false` otherwise.
    /// - Parameter defaultName: The with which a value could be associated
    func hasValue(forKey defaultName: String) -> Bool {
        return self.object(forKey: defaultName) != nil
    }
    
    /// SwifterSwift: Date from UserDefaults.
    ///
    /// - Parameter forKey: key to find date for.
    /// - Returns: Date object for key (if exists).
    func date(forKey key: String) -> Date? {
        return object(forKey: key) as? Date
    }
    
    /// SwifterSwift: Retrieves a Codable object from UserDefaults.
    ///
    /// - Parameters:
    ///   - key: Identifier of the object.
    ///   - decoder: Custom JSONDecoder instance. Defaults to `JSONDecoder()`.
    /// - Returns: Codable object for key (if exists).
    func object<T>(_ key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? where T: Codable {
        guard let data = data(forKey: key) else { return nil }
        return try? T.model(from: data, decoder: decoder)
    }
    
    /// SwifterSwift: Allows storing of Codable objects to UserDefaults.
    ///
    /// - Parameters:
    ///   - object: Codable object to store.
    ///   - key: Identifier of the object.
    ///   - encoder: Custom JSONEncoder instance. Defaults to `JSONEncoder()`.
    func set<T>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) where T: Encodable {
        if let data = try? object.data(encoder) {
            self.set(data, forKey: key)
        } else {
            self.removeObject(forKey: key)
        }
        
    }
}
