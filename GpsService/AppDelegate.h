//
//  AppDelegate.h
//  GpsService
//
//  Created by LiuLei on 12-2-25.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSArray *configTimeArr;  //配置文件更新时间
@property (strong, nonatomic) NSArray *gpsDateArr; //gps提交日期

@property (strong, nonatomic) CLLocationManager *lm;  

//启动检查配置更新
- (void)checkUpConfig:(BOOL)isConfig;

//获得更新配置文件信息
- (void)getConfigUpDate:(NSData *)data;

//获取是否提交定位信息条件
//- (void)getGPSCondition:(NSData *)data;

//定时提交位置信息
- (void)postGPSInfo;

//获取当前位置信息
- (void)getGPSInfo;

//判断是否定时提交位置信息
//- (BOOL)isPostGPSInfo:(NSString *)strYear month:(NSString *)strMonth blDate:(NSArray *)dateArr;

@end
