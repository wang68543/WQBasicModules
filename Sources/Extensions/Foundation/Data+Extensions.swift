//
//  Data+Utilies.swift
//  Alamofire
//
//  Created by WangQiang on 2018/10/27.
//

import Foundation
import CommonCrypto
import CryptoKit
public extension Data {
    var md5: String {
        let len = Int(CC_MD5_DIGEST_LENGTH)
        let bytes = self.bytes
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
        CC_MD5(bytes, CC_LONG(bytes.count - 1), digest)
        var result = String()
        for i in 0..<len { result = result.appendingFormat("%02X", digest[i]) }
        digest.deallocate()
        return result
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
