//
//  UtilityClass.h
//  GpsService
//
//  Created by LiuLei on 12-2-27.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityClass : NSObject

/*!
 * 获取格式化系统时间
 * @param timeFormat 输出系统时间格式 yyyy-MM-dd HH:mm:ss.SSS 可以精确到毫秒
 */
+ (NSString *)getSystemTime:(NSString *)timeFormatStr;

/*!
 * 校验随机数是否已存在
 * @param muArray数组内存放NSNumber数据
 * @param num 生成的随机数
 */
+ (BOOL)checkNum:(NSMutableArray *)arr randNum:(NSInteger)num;
+ (NSMutableArray *)getRandArray:(NSInteger)count;

/*!
 * 数组转换成序列
 */
+ (NSMutableArray *)transArray:(NSMutableArray *)muArray;

/*!
 * CRC32编码 
 */
+ (NSString *)getCRC32Code:(NSString *)srcString;

+ (NSData*) hexStrToBytes:(NSString*)strHex;
+ (NSString *)bytesToHexStr:(NSData *)data;

/*!
 * 获取校验码 
 *@param no 加密的手机号码
 *@param encryptLongitude 加密后的经度
 *@param encryptLatitude 加密的纬度
 *@param systemTime 手机时间不加密，格式如 yyyy-MM-dd HH:mm:ss
 *@param tranArray 序列化后的随机数组 NSNumber对象
 */
+ (NSString *)getVertifyCode:(NSString *)no 
            encryptLongitude:(NSString *)x 
             encryptLatitude:(NSString *)y 
                  systemTime:(NSString *)z 
                   tranArray:(NSMutableArray *)tranArray;

/*!
 * 核对校验码 函数不作null检查 
 * @param   no 加密的手机号码 
 * @param   x 加密后的经度 
 * @param   y 加密后的经度 
 * @param   z 手机时间不加密，格式如 yyyy-MM-dd HH:mm:ss
 * @param   idc
 */
+ (BOOL)checkVerifyCode:(NSString *)no 
       encryptLongitude:(NSString *)x 
        encryptLatitude:(NSString *)y 
             systemTime:(NSString *)z 
                 idcStr:(NSString *)idc;


+ (NSString*)DataToASCIIString:(NSData*)data;
+ (NSData*)ASCIIStringToData:(NSString*)str;

+ (NSString*)DataToUTF8String:(NSData*)data;
+ (NSData*)UTF8StringToData:(NSString*)str;

/*!
 * 获取MD5校验码
 * @param C 字符串
 */
+ (NSString *)md5DigestCString:(const char *)str;

/*!
 * 获取MD5校验码
 * @param NSString字符串对象
 */
+ (NSString *)md5Digest:(NSString *)str;


/*!
 * 获取定时时间增量
 * @param strHour  小时字符串
 * @param strHour  分钟字符串
 * @return 定时时间与系统时间增量
 */
+ (NSInteger)getTimeInterval:(NSString *)strHour strMin:(NSString *)strMinute;

/*!
 * 设置闹铃
 * @param timeInterval  时间增量
 * @param strAlert  闹铃通知内容
 */

+ (void)setAlarm:(NSInteger)timeInterval Alert:(NSString *)strAlert;

@end
