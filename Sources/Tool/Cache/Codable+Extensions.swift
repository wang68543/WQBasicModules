//
//  Codable+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/10/21.
//

import Foundation
  
@inline(__always) func userDefaultsCacheKey(_ name: String, with ext: String) -> String {
    let namespace = (Bundle.main.infoDictionary?[kCFBundleExecutableKey as String] as? String) ?? ""
    var keys: [String] = []
    if !namespace.isEmpty {
        keys.append(namespace)
    }
    if name.isEmpty {
        fatalError("获取名称失败")
    }
    keys.append(name)
    if !ext.isEmpty {
        keys.append(ext)
    }
    return keys.joined(separator: ".")
}

public extension Decodable {
    /// 从缓存中读取
    static func readValue(_ stand: UserDefaults = UserDefaults.standard,
                          decoder: JSONDecoder = JSONDecoder(),
                          with ext: String = "") throws -> Self? {
        let name = String(describing: self)
        let key = userDefaultsCacheKey(name, with: ext)
        guard let data = stand.value(forKey: key) as? Data else { return nil }
        return try decoder.decode(self, from: data)
    }
    
    /// 转为模型或者转为
    static func model(from data: Data, decoder: JSONDecoder = JSONDecoder(), in key: String? = nil) throws -> Self {
        if let kStr = key {
            let obj = try JSONSerialization.jsonObject(with: data, options: [])
            return try self.model(from: obj, decoder: decoder, in: kStr)
        }
        #if !DEBUG
        return try decoder.decode(self, from: data)
        #else
        do {
            return try decoder.decode(self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            debugPrint("dataCorrupted:\(context.codingPath)")
            throw DecodingError.dataCorrupted(context)
        } catch let DecodingError.keyNotFound(key, context) {
            debugPrint("keyNotFound:\(key);;\(context.codingPath)")
            throw DecodingError.keyNotFound(key, context)
        } catch let DecodingError.valueNotFound(value, context) {
            debugPrint("valueNotFound:\(value);;\(context.codingPath)")
            throw DecodingError.valueNotFound(value, context)
        } catch let DecodingError.typeMismatch(type, context) {
            debugPrint("typeMismatch:\(type);;\(context.codingPath)")
            throw DecodingError.typeMismatch(type, context)
        } catch let error {
            debugPrint(error)
            throw error
        }
        #endif
    }
    /// 转为
    static func model(from json: Any, decoder: JSONDecoder = JSONDecoder(), in key: String? = nil) throws -> Self {
        if let data = json as? Data {
            return try self.model(from: data, decoder: decoder, in: key)
        } else {
            var value: Any
            if let kStr = key, let dict = json as? [AnyHashable: Any],
             let dic = dict[kStr] {
                value = dic
            } else {
                value = json
            }
            if JSONSerialization.isValidJSONObject(value) {
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                return try self.model(from: data, decoder: decoder, in: nil)
            } else {
                throw NSError(domain: "CodableExtensions", code: -2000, userInfo: [NSLocalizedDescriptionKey: "Json invailid"])
            }
        }
    }
}
public extension Encodable {
    /// 存储数值到UserDefault中
    func saveValue(_ stand: UserDefaults = UserDefaults.standard,
                   encoder: JSONEncoder = JSONEncoder(),
                   with ext: String = "") throws {
        let data = try encoder.encode(self)
        let name = String(describing: type(of: self))
        let key = userDefaultsCacheKey(name, with: ext)
        stand.set(data, forKey: key)
    }
    
    /// 当前模型转为Data
    func data(_ encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        #if !DEBUG
        return try encoder.encode(self)
        #else
        do {
            return try encoder.encode(self)
        } catch let error {
            debugPrint(error)
            throw error
        }
        #endif
    }
    /// 转为jsonString
    func jsonString(_ encoder: JSONEncoder = JSONEncoder(), encoding: String.Encoding = .utf8) throws -> String? {
        let data = try self.data(encoder)
        return String(data: data, encoding: encoding)
    }
}
// MARK: - handle typeMismatch exceptions in JSONDecoder. You can expand the type of you want.
public extension KeyedDecodingContainer {
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(Int.self, forKey: key) {
            return String(value)
        }
        if let value = try? decode(Float.self, forKey: key) {
            return String(value)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Int(value)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Float(value)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            if let valueInt = Int(value) {
                return Bool(valueInt != 0)
            }
            return nil
        }
        if let value = try? decode(Int.self, forKey: key) {
            return Bool(value != 0)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Double(value)
        }
        return nil
    }
    
    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        return try? decode(type, forKey: key)
    }
}
