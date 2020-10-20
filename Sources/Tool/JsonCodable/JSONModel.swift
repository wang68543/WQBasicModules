//
//  JSONModel.swift
//  WQLib
//
//  Created by iMacHuaSheng on 2020/6/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public let WQJSONModelErrorDomain = "WQJSONModelErrorDomain"
public class JSONModel {
    public func modelToData<T>(_ value: T, encoder: JSONEncoder = JSONEncoder()) throws -> Data where T: Encodable {
        #if !DEBUG
        return try encoder.encode(value)
        #else
        do {
            return try encoder.encode(value)
        } catch let EncodingError.invalidValue(currentValue, context) {
            debugPrint("invalidValue:\(currentValue);;\(context.codingPath)")
            throw EncodingError.invalidValue(currentValue, context)
        }
        #endif
    }
    
    public func jsonToModel<T>(_ data: Any, type: T.Type = T.self, inKey key: String?, decoder: JSONDecoder = JSONDecoder()) throws -> T where T: Decodable {
        var value: Any
        if let valKey = key {
            if let dict = data as? [AnyHashable: Any],
               let result = dict[valKey] {
                value = result
            }
            throw NSError(domain: WQJSONModelErrorDomain, code: -4100, userInfo: [NSLocalizedDescriptionKey: "JSON invalidValue"])
        } else {
            value = data
        }
        guard JSONSerialization.isValidJSONObject(value) else {
            throw NSError(domain: WQJSONModelErrorDomain, code: -4101, userInfo: [NSLocalizedDescriptionKey: "is not json data"])
        }
        do {
            let json = try JSONSerialization.data(withJSONObject: value, options: [])
            return try dataToModel(json, type: type, decoder: decoder)
        } catch let error {
            throw error
        }
    }
    
    public func dataToModel<T>(_ data: Data, type: T.Type = T.self, decoder: JSONDecoder = JSONDecoder()) throws -> T where T: Decodable {
        #if !DEBUG
        return try decoder.decode(type, from: data)
        #else
        do {
            return try decoder.decode(type, from: data)
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
        }
        #endif
    }
}

//public extension Decodable {
//    static func model(_ data: Data?, decoder: JSONDecoder = JSONDecoder()) throws -> Self? {
//        guard let value = data else { return nil}
//        return try? decoder.decode(type(of: Self), from: value)
//    }
//}
public extension Encodable {
    func data(_ encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    
    func jsonString(_ encoder: JSONEncoder = JSONEncoder()) -> String? {
        do {
            let data = try self.data(encoder)
            return String(data: data, encoding: .utf8)
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
}

// MARK: - --解决php从内存读取的时候 数字变为字符串类型
extension KeyedDecodingContainer {

    public func decode<T: Decodable>(_ key: Key, as type: T.Type = T.self) throws -> T {
        return try self.decode(type, forKey: key)
    }
    public func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }
    public func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        if let int = try? decode(type, forKey: key) {
            return int
        } else if let string = try? decode(String.self, forKey: key) {
            return Int(string)
        } else {
            return nil
        }
    }
    public func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        if let double = try? decode(type, forKey: key) {
            return double
        } else if let string = try? decode(String.self, forKey: key) {
            return Double(string)
        } else {
            return nil
        }
    }
}
