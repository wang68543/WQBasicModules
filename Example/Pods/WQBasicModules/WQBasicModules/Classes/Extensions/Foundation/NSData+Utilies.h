//
//  NSData+Utilies.h
//  Alamofire
//
//  Created by WangQiang on 2018/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Utilies)
- (NSString *)md5;
- (nullable NSData *)DESEncode:(NSString *)key;
- (nullable NSData *)DESDecode:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
