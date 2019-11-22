//
//  Data+Utilies.swift
//  Alamofire
//
//  Created by WangQiang on 2018/10/27.
//

import Foundation

public extension Data {
    var md5: String {
        return  (self as NSData).md5()
    }

    func DES(encodeWithKey key: String) -> Data? {
        return (self as NSData).desEncode(key)
    }
    
    func DES(decodeWithKey key: String) -> Data? {
         return (self as NSData).desDecode(key)
    }
    func AES256(encodeWithKey key: String) -> Data? {
        return (self as NSData).aes256Encode(key)
    }
    func AES256(decodeWithKey key: String) -> Data? {
         return (self as NSData).aes256Decode(key)
    }
    
}

// MARK: - -- binary
public extension Data {
    var bytes: [UInt8] {
        // return map { UInt8($0) }
        return [UInt8](self)
    }
    /// 16进制字符串
    var hex: String {
        return map { String(format: "%02hhX", $0) }.joined()
    }
    /// 转为Json
    func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
}
