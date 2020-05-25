//
//  WQString+ExtraCode.swift
//  FBSnapshotTestCase
//
//  Created by hejinyin on 2018/1/31.
//

import Foundation
import CommonCrypto
public extension String {
    /// md5加密 默认小写
    func md5(lower: Bool = true) -> String {
        guard let utf8 = cString(using: .utf8) else { return String() }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8.count - 1), &digest)
        let result = digest.reduce("") { $0 + String(format:"%02X", $1) }
        return lower ? result.lowercased() : result
    }
    
    /**
     * kCCHmacAlgSHA1
     * kCCHmacAlgMD5
     * kCCHmacAlgSHA256
     * kCCHmacAlgSHA384
     * kCCHmacAlgSHA512
     * kCCHmacAlgSHA224
     */
    func hmac(algorithm: CCHmacAlgorithm, key: String) -> String {
        guard let cKey = cString(using: .utf8),
            let cData = self.cString(using: .utf8) else {
            return ""
        }
        var length: Int32 = 0
        switch Int(algorithm) {
        case kCCHmacAlgSHA1:
            length = CC_MD5_DIGEST_LENGTH
        case kCCHmacAlgMD5:
            length = CC_SHA1_DIGEST_LENGTH
        case kCCHmacAlgSHA256:
            length = CC_SHA256_DIGEST_LENGTH
        case kCCHmacAlgSHA384:
            length = CC_SHA384_DIGEST_LENGTH
        case kCCHmacAlgSHA512:
            length = CC_SHA512_DIGEST_LENGTH
        case kCCHmacAlgSHA224:
            length = CC_SHA224_DIGEST_LENGTH
        default:
            return ""
        }
        let len = Int(length)
        var result = [CUnsignedChar](repeating: 0, count: len)
        CCHmac(algorithm, cKey, strlen(cKey), cData, strlen(cData), &result)
        let hmacData = Data(bytes: result, count: len)
        return hmacData.base64EncodedString(options: .lineLength76Characters)
       }
    
//   func oc_sha1() -> String {
//        let str = self as NSString
//        return str.sha1()
//    }
}
