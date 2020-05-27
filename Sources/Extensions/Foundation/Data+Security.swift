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
    
//    func encodeDES(_ keyString: String) throws -> Data {
//        guard keyString.count == kCCKeySizeDES,
//        let key = keyString.data(using: .utf8) else {
//            throw NSError(domain: "key initialization failed", code: kCCInvalidKey, userInfo: nil)
//        }
//
//    }
//    //TODO:-- -DES加密
//    -(NSData *)DESEncode:(NSString *)key{
//        const char *textBytes = self.bytes;
//        NSUInteger dataLength = [self length];
//        unsigned char buffer[1024];
//        memset(buffer, 0,sizeof(char));
//        //向量
//        /**
//         * DES一共就有4个参数参与运作：明文、密文、密钥、向量。为了初学者容易理解，可以把4个参数的关系写成：密文=明文+密钥+向量；明文=密文-密钥-向量。
//         
//         为什么要向量这个参数呢？因为如果有一篇文章，有几个词重复，那么这个词加上密钥形成的密文，仍然会重复，这给破解者有机可乘，破解者可以根据重复的内容，猜出是什么词，然而一旦猜对这个词，那么，他就能算出密钥，整篇文章就被破解了！加上向量这个参数以后，每块文字段都会依次加上一段值，这样，即使相同的文字，加密出来的密文，也是不一样的，算法的安全性大大提高！
//         
//         ** iv向量改成你需要的  key就是你们自己选好的key值 例如 39D}!Az5
//         */
//        const char *iv = [key cStringUsingEncoding:NSASCIIStringEncoding];
//        const char *ASCIIKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
//        //    Byte iv[] = {8,9,4,2,3,0xe,9,8};
//        //
//        size_t numBytesEncrypted = 0;
//        
//        CCCryptorStatus cryptStatus =CCCrypt(kCCEncrypt,
//                                             kCCAlgorithmDES,
//                                             kCCOptionPKCS7Padding,
//                                             ASCIIKey,
//                                             kCCKeySizeDES,
//                                             iv,
//                                             textBytes,
//                                             dataLength,
//                                             buffer,
//                                             1024,
//                                             &numBytesEncrypted);
//        
//        if (cryptStatus == kCCSuccess) {
//            NSData *data = [NSData dataWithBytesNoCopy:buffer length:(NSUInteger)numBytesEncrypted];
//            return data;
//        }
//        return nil;
//    }
//
//    //TODO: -- -DES解密
//    - (NSData *)DESDecode:(NSString*)key {
//        unsigned char buffer[1024];
//        memset(buffer, 0,sizeof(char));
//        size_t numBytesDecrypted = 0;
//        const char *iv = [key cStringUsingEncoding:NSASCIIStringEncoding];
//        const char *ASCIIKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
//        
//        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
//                                              kCCAlgorithmDES,
//                                              kCCOptionPKCS7Padding,
//                                              ASCIIKey,
//                                              kCCKeySizeDES,
//                                              iv,
//                                              self.bytes,
//                                              self.length,
//                                              buffer,
//                                              1024,
//                                              &numBytesDecrypted);
//        if (cryptStatus == kCCSuccess) {
//            NSData* data = [NSData dataWithBytesNoCopy:buffer length:(NSUInteger)numBytesDecrypted];
//            return data;
//        }
//        return nil;
//    }
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
