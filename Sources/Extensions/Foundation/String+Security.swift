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

private func string(fromBytes bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        var hash = String()
        for i in 0..<length {
         hash = hash.appendingFormat("%02X", bytes[i])
        }
        bytes.deallocate()
        return hash
}
public extension String {

    var isNotEmpty: Bool { !isEmpty }
    /// 转换拼音
    /// - Parameter stripDiacritics: 是否去除音标
    ///   - trimming: 是否去除拼音间的间隔
    func pinYin(_ stripDiacritics: Bool = true, trimming: Bool = true) -> String {
        guard let contents = CFStringCreateMutableCopy(kCFAllocatorDefault, 0, self as CFString) else {
            return self
        }
        CFStringTransform(contents, nil, kCFStringTransformMandarinLatin, false) // 转化成拼音
        if stripDiacritics {
            CFStringTransform(contents, nil, kCFStringTransformStripDiacritics, false) // 去除音标
        }
        let string = contents as String
        if trimming {
            return string.replacingOccurrences(of: " ", with: "")
        } else {
            return string
        }
    }

    /// md5加密 默认小写
    func md5String(lower: Bool = true) -> String {
        guard let utf8 = cString(using: .utf8) else { return String() }
        let len = Int(CC_MD5_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
        CC_MD5(utf8, CC_LONG(strlen(utf8)), digest)
        let result = string(fromBytes: digest, length: len)
        return lower ? result.lowercased() : result
    }
    func sha1String(lower: Bool = true) -> String {
        guard let utf8 = cString(using: .utf8) else { return String() } // cString(using: .utf8) 转换之后 会自带一个\0 就是长度加长了1个
        let len = Int(CC_SHA1_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
        CC_SHA1(utf8, CC_LONG(strlen(utf8)), digest)
        let result = string(fromBytes: digest, length: len)
        return lower ? result.lowercased() : result
    }
//    func sha1() -> String {
//        guard let data = cString(using: .utf8) else { return String() }
//        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
//        CC_SHA1(data, CC_LONG(data.count), &digest)
//        let hexBytes = digest.map { String(format: "%02hhx", $0) }
//        return hexBytes.joined(separator: "")
//    }
    func sha256String(lower: Bool = true) -> String {
      guard let utf8 = cString(using: .utf8) else { return String() }
      let len = Int(CC_SHA256_DIGEST_LENGTH)
      let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
      CC_SHA256(utf8, CC_LONG(strlen(utf8)), digest)
      let result = string(fromBytes: digest, length: len)
      return lower ? result.lowercased() : result
    }
    func sha512String(lower: Bool = true) -> String {
        guard let utf8 = cString(using: .utf8) else { return String() }
        let len = Int(CC_SHA512_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
        CC_SHA512(utf8, CC_LONG(strlen(utf8)), digest)
        let result = string(fromBytes: digest, length: len)
        return lower ? result.lowercased() : result
    }
    ///https://github.com/laevandus/CommonCryptoExample
    func hmacString(_ algorithm: CCAlgorithmType, key: String) -> String {
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
//    @available(*, deprecated, message: "use sha1String")
//    func oc_sha1() -> String {
//        return (self as NSString).sha1()
//    }
}
