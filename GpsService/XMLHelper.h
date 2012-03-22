//
//  XMLHelper.h
//  GpsService
//
//  Created by LiuLei on 12-3-2.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLHelper : NSObject


/*!
 * 获取配置文件单一节点
 * @param firstNode
 */
+ (NSString *)getNodeStr:(NSString *)firstNode;

/*!
 * 获取配置文件单一节点
 * @param firstNode
 * @param secNode
 */
+ (NSString *)getNodeStr:(NSString *)firstNode secondNode:(NSString *)secNode;

@end
