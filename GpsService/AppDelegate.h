//
//  AppDelegate.h
//  GpsService
//
//  Created by LiuLei on 12-2-25.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) NSArray *configTimeArr;  //配置文件更新时间
//启动检查配置更新
- (void)checkUpConfig;
//获得激活http地址
- (void)getHostStr:(NSData *)data;

@end
