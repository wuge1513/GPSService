//
//  MD5+Encrypt.m
//  GpsService
//
//  Created by LiuLei on 12-2-27.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import "PBEWithMD5AndDES.h"
#import "UtilityClass.h"

static NSString *defaultPwd = @"WoAiBeiJingTianAnMen";
static Byte salt[] = { 24, -121, -109, 109, 53, 58, 106, -96 };
static NSInteger numIterations = 100;



@implementation PBEWithMD5AndDES

#pragma mark-
#pragma mark-DES加密


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
                    andIterating:(NSInteger)numIterations {
    
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    memset(md5, 0, CC_MD5_DIGEST_LENGTH);
    NSData* passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    CC_MD5_CTX ctx;
    CC_MD5_Init(&ctx);
    CC_MD5_Update(&ctx, [passwordData bytes], [passwordData length]);
    CC_MD5_Update(&ctx, [salt bytes], [salt length]);
    CC_MD5_Final(md5, &ctx);
    
    for (int i=1; i<numIterations; i++) {
        CC_MD5(md5, CC_MD5_DIGEST_LENGTH, md5);
    }
    
    size_t cryptoResultDataBufferSize = [data length] + kCCBlockSizeDES;//
    unsigned char cryptoResultDataBuffer[cryptoResultDataBufferSize];
    size_t dataMoved = 0;
    
    unsigned char iv[kCCBlockSizeDES];
    memcpy(iv, md5 + (CC_MD5_DIGEST_LENGTH/2), sizeof(iv)); //iv is the second half of the MD5 from building the key
    
    CCCryptorStatus status =
    CCCrypt(op, kCCAlgorithmDES, kCCOptionPKCS7Padding, md5, (CC_MD5_DIGEST_LENGTH/2), iv, [data bytes], [data length],
            cryptoResultDataBuffer, cryptoResultDataBufferSize, &dataMoved);
    
    if(0 == status) {
        NSLog(@"rsult===%@", [NSData dataWithBytes:cryptoResultDataBuffer length:dataMoved]);
        return [NSData dataWithBytes:cryptoResultDataBuffer length:dataMoved];
    } else {
        return NULL;
    }
}

/**
 * @param str 需要加密的字符串
 * @param pwd 用户输入密匙 若为空则使用默认密匙
 * @return 加密结果字符串
 */

+ (NSString*) encrypt:(NSString *)str password:(NSString *)pwd
{
    NSAssert(str, @"encrypt:str is nil");
    
    if ([pwd isEqualToString:@""] || pwd == nil) {
        pwd = defaultPwd;
        NSLog(@"encrypt:pwd = %@", pwd);
    }
    
    NSData *dataSalt = [[[NSData alloc] initWithBytes:salt length:8] autorelease];
    NSData *dataStr = [UtilityClass UTF8StringToData:str];
    //NSLog(@"xxx = datast = %@r", dataStr);
    NSData *dataResult = [PBEWithMD5AndDES cryptPBEWithMD5AndDES:kCCEncrypt
                                                       usingData:dataStr 
                                                    withPassword:pwd 
                                                         andSalt:dataSalt 
                                                    andIterating:numIterations];
    
    NSString *strResult = [UtilityClass bytesToHexStr:dataResult];
    
    return strResult;
}

/**
 * @param str 需要解密的字符串
 * @param pwd 用户输入密匙 若为空则使用默认密匙
 * @return 解密结果字符串
 */
+ (NSString*) decrypt:(NSString *)str password:(NSString *)pwd
{ 
    NSAssert(str, @"decrypt:str is nil");

    if ([pwd isEqualToString:@""] || pwd == nil) {
        pwd = defaultPwd;
        NSLog(@"decrypt:pwd = %@", pwd);
    }
    
    NSData *dataSalt = [[NSData alloc] initWithBytes:salt length:8];
    NSData *dataStr = [UtilityClass hexStrToBytes:str];
    NSData *dataResult = [PBEWithMD5AndDES cryptPBEWithMD5AndDES:kCCDecrypt
                                                  usingData:dataStr 
                                               withPassword:pwd 
                                                    andSalt:dataSalt 
                                               andIterating:numIterations];
    
    NSString *strResult = [UtilityClass DataToUTF8String:dataResult];
    
    return strResult;
}

@end
