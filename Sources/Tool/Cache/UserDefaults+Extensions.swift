//
//  UserDefaults+Extensions.swift
//  Pods
//
//  Created by WQ on 2019/6/21.
//

import Foundation
import SwifterSwift
public extension UserDefaults {

    /// Returns `true` if any value is associated with the given key, `false` otherwise.
    /// - Parameter defaultName: The with which a value could be associated
    func hasValue(forKey defaultName: String) -> Bool {
        return self.object(forKey: defaultName) != nil
    }

    func object<T>(_ key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? where T: Codable {
        guard let data = data(forKey: key) else { return nil }
        guard data != UserDefaults.nullValue else { return nil }
        return object(T.self, with: key, usingDecoder: decoder)
//        return try? T.model(from: data, decoder: decoder)
    }

//    /// SwifterSwift: Allows storing of Codable objects to UserDefaults.
//    ///
//    /// - Parameters:
//    ///   - object: Codable object to store.
//    ///   - key: Identifier of the object.
//    ///   - encoder: Custom JSONEncoder instance. Defaults to `JSONEncoder()`.
//    func set<T>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) where T: Encodable {
//        set
//        if let data = try? object.toJSON(encoder) {
//            self.set(data, forKey: key)
//        } else {
//            self.removeObject(forKey: key)
//        }
//        
//    }
}
extension UserDefaults {
    static let nullValue = "null".data(using: .utf8)!
}
