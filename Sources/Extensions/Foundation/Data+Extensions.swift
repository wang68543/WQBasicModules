//
//  Data+Utilies.swift
//  Alamofire
//
//  Created by WangQiang on 2018/10/27.
//

import Foundation
import CommonCrypto
public extension Data {
    var isNotEmpty: Bool { !isEmpty }
    var md5: String {
        let len = Int(CC_MD5_DIGEST_LENGTH)
        let bytes = self.bytes
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
        CC_MD5(bytes, CC_LONG(bytes.count), digest)
        var result = String()
        for i in 0..<len { result = result.appendingFormat("%02X", digest[i]) }
        digest.deallocate()
        return result
    }
}

// MARK: - -- binary
public extension Data {

    /// hex string to data
    init?(hex string: String) {
        guard let chars = string.cString(using: .utf8),
              !chars.isEmpty else { return nil }
        let length = chars.count / 2
        var data = Data(capacity: length)
        var byteChars: [CChar] = Array(repeating: .zero, count: 3)
        var byte: UInt8 = .zero
        for idx in 0..<length {
            byteChars[0] = chars[idx*2]
            byteChars[1] = chars[idx*2+1]
            byte = UInt8(strtoul(byteChars, nil, 16))
            data.append(&byte, count: 1)
         }
         self = data
    }

    /// var bytes: [UInt8] = [0xDE, 0xAD, 0xBE, 0xEF, 0x42]
    var bytes: [UInt8] {
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
