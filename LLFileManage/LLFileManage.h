//
//  LLFileManage.h
//  GpsService
//
//  Created by LiuLei on 12/3/10.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LLFileManage : NSObject

/*! 
 * 创建路径
 * @param fileName 文件名
 * @return 返回文件完整路径
 */
+ (NSString *) createFilePath:(NSString *)fileName;

/*!
 * 判断文件是否存在
 * @param fileName 文件名
 */
+ (BOOL)fileIsExist:(NSString *)fileName;

/*!
 * 存储文件
 * @param fileName 文件名
 */
+ (void)WritteToFile:(NSData *)sender FileName:(NSString *)fileName;

/*!
 * 读取文件
 * @param fileName 文件名称
 *
 */
+ (NSData *)ReadFromFile:(NSString *)fileName;

/*!
 * 删除文件
 * @param fileName 文件名
 */
+ (void)DeleteFile:(NSString *)fileName;

/*!
 * 加载资源包内文件
 * @param fileName 文件名
 * @param type  文件类型，扩展名
 */

+ (NSData *)ReadLocalFile:(NSString *)fileName FileType:(NSString *)type;


@end
