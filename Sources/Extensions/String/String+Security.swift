//
//  WQString+ExtraCode.swift
//  FBSnapshotTestCase
//
//  Created by hejinyin on 2018/1/31.
//

import Foundation
import CommonCrypto

public enum CCAlgorithmType {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    var hmacAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

fileprivate func string(fromBytes bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        var hash = String()
        for i in 0..<length {
         hash = hash.appendingFormat("%02X", bytes[i])
        }
        bytes.deallocate()
        return hash
}
public extension String {
    /// md5加密 默认小写
    func md5(lower: Bool = true) -> String {
        guard let utf8 = cString(using: .utf8) else { return String() }
        let len = Int(CC_MD5_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
        CC_MD5(utf8, CC_LONG(utf8.count - 1), digest)
        let result = string(fromBytes: digest, length: len)
        return lower ? result.lowercased() : result
    }
    func sha1(lower: Bool = true) -> String {
        guard let utf8 = cString(using: .utf8) else { return String() }
        let len = Int(CC_SHA1_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
        CC_SHA1(utf8, CC_LONG(utf8.count), digest)
        let result = string(fromBytes: digest, length: len)
        return lower ? result.lowercased() : result
    }
    func sha256(lower: Bool = true) -> String {
      guard let utf8 = cString(using: .utf8) else { return String() }
      let len = Int(CC_SHA256_DIGEST_LENGTH)
      let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
      CC_SHA256(utf8, CC_LONG(utf8.count), digest)
      let result = string(fromBytes: digest, length: len)
      return lower ? result.lowercased() : result
    }
    func sha512(lower: Bool = true) -> String {
        guard let utf8 = cString(using: .utf8) else { return String() }
        let len = Int(CC_SHA512_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
        CC_SHA512(utf8, CC_LONG(utf8.count), digest)
        let result = string(fromBytes: digest, length: len)
        return lower ? result.lowercased() : result
    }
    func hmac(_ algorithm: CCAlgorithmType, key: String) -> String {
        guard let cKey = cString(using: .utf8),
            let cData = self.cString(using: .utf8) else {
            return ""
        }
        let len = algorithm.digestLength
        var result = [CUnsignedChar](repeating: 0, count: len)
        CCHmac(algorithm.hmacAlgorithm, cKey, strlen(cKey), cData, strlen(cData), &result)
        let hmacData = Data(bytes: result, count: len)
        return hmacData.base64EncodedString(options: .lineLength76Characters)
       }
}
