//
//  Data+Security.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/5/25.
//

import Foundation
import CommonCrypto

public extension Data {
    func encodeAES256(_ keyString: String, ivSize: Int = kCCBlockSizeAES128, options: CCOptions = CCOptions(kCCOptionPKCS7Padding)) throws -> Data {
        guard keyString.count == kCCKeySizeAES256,
        let key = keyString.data(using: .utf8) else {
            throw NSError(domain: "key initialization failed", code: kCCInvalidKey, userInfo: nil)
        }
        let bufferSize: Int = ivSize + self.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        let status: Int32 = buffer.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(
                kSecRandomDefault,
                kCCBlockSizeAES128,
                bytes.baseAddress!
            )
        }
        guard status == errSecSuccess else {
            throw NSError(domain: "key initialization failed", code: kCCBufferTooSmall, userInfo: nil)
        }

        var numberBytesEncrypted: Int = 0
        let cryptStatus: CCCryptorStatus = key.withUnsafeBytes { keyBytes in
            self.withUnsafeBytes { dataBytes in
                buffer.withUnsafeMutableBytes {bufferBytes in
                    CCCrypt( // Stateless, one-shot encrypt operation
                        CCOperation(kCCEncrypt),                // op: CCOperation
                        CCAlgorithm(kCCAlgorithmAES),           // alg: CCAlgorithm
                        options,                                // options: CCOptions
                        keyBytes.baseAddress,                   // key: the "password"
                        key.count,                              // keyLength: the "password" size
                        bufferBytes.baseAddress,                // iv: Initialization Vector
                        dataBytes.baseAddress,                  // dataIn: Data to encrypt bytes
                        self.count,                    // dataInLength: Data to encrypt size
                        bufferBytes.baseAddress! + kCCBlockSizeAES128, // dataOut: encrypted Data buffer
                        bufferSize,                             // dataOutAvailable: encrypted Data buffer size
                        &numberBytesEncrypted                   // dataOutMoved: the number of bytes written
                    )
                }
            }
        }
        guard cryptStatus == kCCSuccess else {
            throw NSError(domain: "key initialization failed", code: kCCDecodeError, userInfo: nil)
        }
        return buffer.prefix(numberBytesEncrypted + ivSize)
    }
    func decodeAES256(_ keyString: String, ivSize: Int = kCCBlockSizeAES128, options: CCOptions = CCOptions(kCCOptionPKCS7Padding)) throws -> Data {
        guard keyString.count == kCCKeySizeAES256,
        let key = keyString.data(using: .utf8) else {
            throw NSError(domain: "key initialization failed", code: kCCInvalidKey, userInfo: nil)
        }
        let bufferSize: Int = self.count - ivSize
        var buffer = Data(count: bufferSize)

        var numberBytesDecrypted: Int = 0 
        let cryptStatus: CCCryptorStatus = key.withUnsafeBytes {keyBytes in
            self.withUnsafeBytes {dataBytes in
                buffer.withUnsafeMutableBytes {bufferBytes in
                    CCCrypt(         // Stateless, one-shot encrypt operation
                        CCOperation(kCCDecrypt),                        // op: CCOperation
                        CCAlgorithm(kCCAlgorithmAES128),                // alg: CCAlgorithm
                        options,                                        // options: CCOptions
                        keyBytes.baseAddress,                           // key: the "password"
                        key.count,                                      // keyLength: the "password" size
                        dataBytes.baseAddress,                          // iv: Initialization Vector
                        dataBytes.baseAddress! + kCCBlockSizeAES128,    // dataIn: Data to decrypt bytes
                        bufferSize,                                     // dataInLength: Data to decrypt size
                        bufferBytes.baseAddress,                        // dataOut: decrypted Data buffer
                        bufferSize,                                     // dataOutAvailable: decrypted Data buffer size
                        &numberBytesDecrypted                           // dataOutMoved: the number of bytes written
                    )
                }
            }
        }
        guard cryptStatus == kCCSuccess else {
            throw NSError(domain: "key initialization failed", code: kCCDecodeError, userInfo: nil)
        }
        return buffer.prefix(numberBytesDecrypted)
//        let decryptedData = buffer[..<numberBytesDecrypted]
//
//        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
//            throw AESError.dataToStringFailed
//        }
//
//        return decryptedString
    }
}
//public struct AES {
//     private let key: Data //<- Use `Data` instead of `NSData`
//     private let ivSize: Int                     = kCCBlockSizeAES128
//     private let options: CCOptions              = CCOptions(kCCOptionPKCS7Padding)
//
//     init(keyString: String) throws {
//         guard keyString.count == kCCKeySizeAES256 else {
//             throw NSError(domain: "AES initialization failed", code: kCCInvalidKey, userInfo: nil)
//         }
//         guard let keyData: Data = keyString.data(using: .utf8) else {
//             throw NSError(domain: "AES initialization failed", code: kCCInvalidKey, userInfo: nil)
//         }
//         self.key = keyData
//     }
// }
//extension AES: Cryptable {
////    func encrypt(_ string: String) throws -> Data {
////        guard let dataToEncrypt: Data = string.data(using: .utf8) else {
////            throw AESError.stringToDataFailed
////        }
////
////        let bufferSize: Int = ivSize + dataToEncrypt.count + kCCBlockSizeAES128
////        var buffer = Data(count: bufferSize)
////
////        let status: Int32 = buffer.withUnsafeMutableBytes {bytes in
////            SecRandomCopyBytes(
////                kSecRandomDefault,
////                kCCBlockSizeAES128,
////                bytes.baseAddress!
////            )
////        }
////        guard status == 0 else {
////            throw AESError.generateRandomIVFailed
////        }
////
////        var numberBytesEncrypted: Int = 0
////
////        let cryptStatus: CCCryptorStatus = key.withUnsafeBytes {keyBytes in
////            dataToEncrypt.withUnsafeBytes {dataBytes in
////                buffer.withUnsafeMutableBytes {bufferBytes in
////                    CCCrypt( // Stateless, one-shot encrypt operation
////                        CCOperation(kCCEncrypt),                // op: CCOperation
////                        CCAlgorithm(kCCAlgorithmAES),           // alg: CCAlgorithm
////                        options,                                // options: CCOptions
////                        keyBytes.baseAddress,                   // key: the "password"
////                        key.count,                              // keyLength: the "password" size
////                        bufferBytes.baseAddress,                // iv: Initialization Vector
////                        dataBytes.baseAddress,                  // dataIn: Data to encrypt bytes
////                        dataToEncrypt.count,                    // dataInLength: Data to encrypt size
////                        bufferBytes.baseAddress! + kCCBlockSizeAES128, // dataOut: encrypted Data buffer
////                        bufferSize,                             // dataOutAvailable: encrypted Data buffer size
////                        &numberBytesEncrypted                   // dataOutMoved: the number of bytes written
////                    )
////                }
////            }
////        }
////
////        guard cryptStatus == CCCryptorStatus(kCCSuccess) else {
////            throw AESError.encryptDataFailed
////        }
////
////        return buffer[..<(numberBytesEncrypted + ivSize)]
////    }
//
////    func decrypt(_ data: Data) throws -> String {
////
////        let bufferSize: Int = data.count - ivSize
////        var buffer = Data(count: bufferSize)
////
////        var numberBytesDecrypted: Int = 0
////
////        let cryptStatus: CCCryptorStatus = key.withUnsafeBytes {keyBytes in
////            data.withUnsafeBytes {dataBytes in
////                buffer.withUnsafeMutableBytes {bufferBytes in
////                    CCCrypt(         // Stateless, one-shot encrypt operation
////                        CCOperation(kCCDecrypt),                        // op: CCOperation
////                        CCAlgorithm(kCCAlgorithmAES128),                // alg: CCAlgorithm
////                        options,                                        // options: CCOptions
////                        keyBytes.baseAddress,                           // key: the "password"
////                        key.count,                                      // keyLength: the "password" size
////                        dataBytes.baseAddress,                          // iv: Initialization Vector
////                        dataBytes.baseAddress! + kCCBlockSizeAES128,    // dataIn: Data to decrypt bytes
////                        bufferSize,                                     // dataInLength: Data to decrypt size
////                        bufferBytes.baseAddress,                        // dataOut: decrypted Data buffer
////                        bufferSize,                                     // dataOutAvailable: decrypted Data buffer size
////                        &numberBytesDecrypted                           // dataOutMoved: the number of bytes written
////                    )
////                }
////            }
////        }
////
////        guard cryptStatus == CCCryptorStatus(kCCSuccess) else {
////            throw AESError.decryptDataFailed
////        }
////
////        let decryptedData = buffer[..<numberBytesDecrypted]
////
////        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
////            throw AESError.dataToStringFailed
////        }
////
////        return decryptedString
////    }
//}
public extension Data {
//    func MD5() -> String {
//           var buffer: [UInt8] = []
//           //CC_MD5_DIGEST_LENGTH
//           var bytes = self.bytes
//        
//           let values = CC_MD5(&bytes, CC_LONG(bytes.count), &buffer)
//           var result: String = ""
//           buffer.forEach { byte in
//               result += String(format: "%02X", byte)
//           }
//           return result
//       }
 



//    func encodeDES(_ key: String) throws -> Data {
//
//    }
//    - (nullable NSData *)DESEncode:(NSString *)key;
//    - (nullable NSData *)DESDecode:(NSString *)key;
//    - (nullable NSData *)AES256Encode:(NSString *)key;
//    - (nullable NSData *)AES256Decode:(NSString *)key;
}
