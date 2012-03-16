//
//  MD5+Encrypt.h
//  GpsService
//
//  Created by LiuLei on 12-2-27.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import <Foundation/Foundation.h>
//<MD5>
#import <CommonCrypto/CommonDigest.h>
//<DES>
#import <CommonCrypto/CommonCryptor.h>


@interface PBEWithMD5AndDES : NSObject

/**
 * 加密工具
 * @param op 加密or解密
 * @param data 加密数据
 * @param password 加密密匙
 * @param salt 盐
 * @return 加密结果
 */
+(NSData*) cryptPBEWithMD5AndDES:(CCOperation)op 
                       usingData:(NSData*)data 
                    withPassword:(NSString*)password 
                         andSalt:(NSData*)salt 
                    andIterating:(NSInteger)numIterations;


/**
 * @param str 需要加密的字符串
 * @param pwd 用户输入密匙 若为空则使用默认密匙
 * @return 加密结果字符串
 */

+ (NSString*) encrypt:(NSString *)str password:(NSString *)pwd;


/**
 * @param str 需要解密的字符串
 * @param pwd 用户输入密匙 若为空则使用默认密匙
 * @return 解密结果字符串
 */
+ (NSString*) decrypt:(NSString *)str password:(NSString *)pwd;

@end
