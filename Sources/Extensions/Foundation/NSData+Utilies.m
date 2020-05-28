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
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:(NSUInteger)numBytesEncrypted];
        return data;
    }
    free(buffer);
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
        NSData* data = [NSData dataWithBytesNoCopy:buffer length:(NSUInteger)numBytesDecrypted];
        return data;
    }
    free(buffer);
    return nil;
}
//  加密
-(NSData *)AES256Encode:(NSString *)key
{
  // 定义一个字符数组keyPtr，元素个数是kCCKeySizeAES256+1
  // AES256加密，密钥应该是32位的
  char keyPtr[kCCKeySizeAES256+1];
  // sizeof(keyPtr) 数组keyPtr所占空间的大小，即多少个个字节
  // bzero的作用是字符数组keyPtr的前sizeof(keyPtr)个字节为零且包括‘\0’。就是前32位为0，最后一位是\0
  bzero(keyPtr, sizeof(keyPtr));
  // NSString转换成C风格字符串
  [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

  NSUInteger dataLength = [self length];
  // buffer缓冲，缓冲区
  //  对于块加密算法：输出的大小<= 输入的大小 +  一个块的大小
  size_t bufferSize = dataLength + kCCBlockSizeAES128;
  //  *malloc()*函数其实就在内存中找一片指定大小的空间
  void *buffer = malloc(bufferSize);
  // size_t的全称应该是size type，就是说“一种用来记录大小的数据类型”。通常我们用sizeof(XXX)操作，这个操作所得到的结果就是size_t类型。
  // 英文翻译：num 数量 Byte字节  encrypt解密
  size_t numBytesEncrypted = 0;
  // **<CommonCrypto/CommonCryptor.h>框架下的类与方法**p苹果提供的
  CCCryptorStatus cryptStatus = CCCrypt(
                                       kCCEncrypt,
                                       kCCAlgorithmAES128,
                                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                                       keyPtr,
                                       kCCBlockSizeAES128,
                                       NULL,
                                       [self bytes],
                                       dataLength,
                                       buffer,
                                       bufferSize,
                                       &numBytesEncrypted);
  if (cryptStatus == kCCSuccess) {
     return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
  }
  free(buffer);
  return nil;
}

//  解密
- (NSData *)AES256Decode:(NSString *)key
{
   char keyPtr[kCCKeySizeAES256+1];
   bzero(keyPtr, sizeof(keyPtr));
   [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
   NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
   void *buffer = malloc(bufferSize);
   size_t numBytesDecrypted = 0;
   CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,keyPtr, kCCBlockSizeAES128, NULL,[self bytes], dataLength, buffer, bufferSize,  &numBytesDecrypted);
   if (cryptStatus == kCCSuccess) {
     return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
   }
    free(buffer);
   return nil;
}

- (NSString *)wm_sha1 {
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (unsigned int)self.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02X", digest[i]];
     }
    return output;
}
@end
