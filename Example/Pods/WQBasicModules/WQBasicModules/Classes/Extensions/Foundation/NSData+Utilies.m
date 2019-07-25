//
//  NSData+Utilies.m
//  Alamofire
//
//  Created by WangQiang on 2018/10/27.
//

#import "NSData+Utilies.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
@implementation NSData (Utilies)
- (NSString *)md5 {
    unsigned char buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)strlen(self.bytes), buffer);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [result appendFormat:@"%02X", buffer[i]];
    }
    return result;
}
//TODO:-- -DES加密
-(NSData *)DESEncode:(NSString *)key{
    const char *textBytes = self.bytes;
    NSUInteger dataLength = [self length];
    unsigned char buffer[1024];
    memset(buffer, 0,sizeof(char));
    //向量
    /**
     * DES一共就有4个参数参与运作：明文、密文、密钥、向量。为了初学者容易理解，可以把4个参数的关系写成：密文=明文+密钥+向量；明文=密文-密钥-向量。
     
     为什么要向量这个参数呢？因为如果有一篇文章，有几个词重复，那么这个词加上密钥形成的密文，仍然会重复，这给破解者有机可乘，破解者可以根据重复的内容，猜出是什么词，然而一旦猜对这个词，那么，他就能算出密钥，整篇文章就被破解了！加上向量这个参数以后，每块文字段都会依次加上一段值，这样，即使相同的文字，加密出来的密文，也是不一样的，算法的安全性大大提高！
     
     ** iv向量改成你需要的  key就是你们自己选好的key值 例如 39D}!Az5
     */
    const char *iv = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *ASCIIKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
    //    Byte iv[] = {8,9,4,2,3,0xe,9,8};
    //
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus =CCCrypt(kCCEncrypt,
                                         kCCAlgorithmDES,
                                         kCCOptionPKCS7Padding,
                                         ASCIIKey,
                                         kCCKeySizeDES,
                                         iv,
                                         textBytes,
                                         dataLength,
                                         buffer,
                                         1024,
                                         &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        return data;
//        ciphertext = [[NSString alloc] initWithData:[data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength]encoding:NSUTF8StringEncoding];
    }
    return nil;
}

//TODO: -- -DES解密
- (NSData *)DESDecode:(NSString*)key {
    unsigned char buffer[1024];
    memset(buffer, 0,sizeof(char));
    size_t numBytesDecrypted = 0;
    const char *iv = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *ASCIIKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          ASCIIKey,
                                          kCCKeySizeDES,
                                          iv,
                                          self.bytes,
                                          self.length,
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        return data;
    }
    return nil;
}

- (NSString *)SHA1 {
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (unsigned int)self.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02X", digest[i]];
     }
    return output;
}
@end
