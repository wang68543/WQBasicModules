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
@end
