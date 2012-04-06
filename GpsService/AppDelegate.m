//
//  AppDelegate.m
//  GpsService
//
//  Created by LiuLei on 12-2-25.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"

#import "UtilityClass.h"
#import "TBXML.h"
#import "LLFileManage.h"
#import "PBEWithMD5AndDES.h"
#import "ASIFormDataRequest.h"
#import "XMLHelper.h"

static NSString *strLatitude = @"";  //纬度
static NSString *strLongitude= @"";  //经度
static NSString *strAccuracy = @"";  //精确度

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize configTimeArr, gpsDateArr;
@synthesize lm;


- (void)dealloc
{
    [lm release];
    [gpsDateArr release];
    [configTimeArr release];
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"000");
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
	for(UILocalNotification *notification in localNotifications)
	{
		if ([[[notification userInfo] objectForKey:@"ActivityClock"] isEqualToString:@"123"]) {
			NSLog(@"Shutdown localNotification:%@", [notification fireDate]);
			[[UIApplication sharedApplication] cancelLocalNotification:notification];
            NSLog(@"131");
		}
	}
    
    //程序启动检查配置更新
    //[self checkUpConfig:YES];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
  
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"001 app will enter ResignActive");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

//接收定时通知代理
-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收定时通知代理");
    //启动检查配置更新
    //[self checkUpConfig:YES];
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    [[UIApplication sharedApplication] openURL:url];
    
    //判断是否提交位置信息, 提交位置信息
    //[self checkUpConfig:NO];
}

//进入后台，设置定时
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"002 app will enter Background");
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
//    NSInteger timeInterval = [UtilityClass getTimeInterval:@"17" strMin:@"15"];
//    [UtilityClass setAlarm:timeInterval Alert:@"你好！"];
    

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

    NSLog(@"003 app will enter foreground");
    //[self actionAPP];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"004 app did become active");
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"005 app will Terminate");
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}



#pragma mark- 检查配置文件更新
//启动检查配置更新
- (void)checkUpConfig:(BOOL)isConfig
{
    NSLog(@"启动检查配置更新");
    //判断配置文件是否已经下载
    NSString *fileName = @"config.xml";
    BOOL fileIsExist = [LLFileManage fileIsExist:fileName];
    if (fileIsExist) {
        NSLog(@"已经下载到本地");
        NSData *data = [LLFileManage ReadFromFile:fileName];
        //NSLog(@"data1==%@", data);
        if (isConfig) {
            [self getConfigUpDate:data];
        }else{
            [self getGPSCondition:data];
        }
        
    }
    else{        
        NSData *data = [LLFileManage ReadLocalFile:@"config" FileType:@"xml"];
        //NSLog(@"data2==%@", data);
        if (isConfig) {
            [self getConfigUpDate:data];
        }else{
            [self getGPSCondition:data];
        }
    }
}


//获得更新配置文件信息
- (void)getConfigUpDate:(NSData *)data
{
    NSAssert(data, @"Check update: local file is nil");
    
    TBXML *tbxml = [TBXML tbxmlWithXMLData:data error:nil];
    
    TBXMLElement * root = tbxml.rootXMLElement;
	
	if (root) {
        
        NSString *strCX = @"";
        NSString *strVersion = @"";
        NSString *strConfigUrl = @"";
        NSString *strTime = @"";
        
        TBXMLElement *config_update = [TBXML childElementNamed:@"config-update" parentElement:root];
        if (config_update) {
            
            //配置文件版本号
            TBXMLElement *cxX = [TBXML childElementNamed:@"cx" parentElement:config_update];
            if (cxX) {
                strCX = [TBXML textForElement:cxX];
                NSLog(@"strCX = %@", strCX);
            }
            //配置文件版本号
            TBXMLElement *cyX = [TBXML childElementNamed:@"cy" parentElement:config_update];
            if (cyX) {
                strVersion = [TBXML textForElement:cyX];
                NSLog(@"strVersion = %@", strVersion);
            }
            //配置文件更新地址
            TBXMLElement *config_update_url = [TBXML childElementNamed:@"config-update-url" parentElement:config_update];
            if (config_update_url) {
                strConfigUrl = [TBXML textForElement:config_update_url];
                NSLog(@"strConfigUrl = %@", strConfigUrl);
            }
            //配置文件更新时间
            TBXMLElement *time = [TBXML childElementNamed:@"time" parentElement:config_update];
            if (time) {
                strTime = [TBXML textForElement:time];
                NSLog(@"strTime = %@", strTime);
    
                NSArray *arr = [[[NSArray alloc] init] autorelease]; 
                arr = [strTime componentsSeparatedByString:@","];
                self.configTimeArr = [NSArray arrayWithArray:arr];
                NSLog(@"sss = %@", self.configTimeArr);
               
            }
            
            
            NSString *no = [XMLHelper getNodeStr:@"mobile-no"];//手机号码
            NSString *cx = strCX;
            NSString *cy = strVersion;
            NSString *ct = [UtilityClass getSystemTime:@"yyyy-MM-dd HH:mm:ss"];     //手机时间 （安全校验用）
            
            
            NSString *_no = [PBEWithMD5AndDES encrypt:no password:nil];
            NSString *_cx = [PBEWithMD5AndDES encrypt:cx password:nil];
            NSString *_cy = [PBEWithMD5AndDES encrypt:cy password:nil];
            
            // 获取0-9之间4个不重复的随机数的数组  对象
            NSMutableArray *arans = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
            arans = [UtilityClass getRandArray:4];
            
            NSInteger arr[4];
            for (int i = 0; i < 4; i++) {
                arr[i] = [[arans objectAtIndex:i] integerValue];
            }
            
            //随机数组序列化
            NSMutableArray *transArr = [[[NSMutableArray alloc] initWithCapacity:4] autorelease]; 
            
            transArr = [UtilityClass transArray:arans];
            
            //用于打印测试
            NSInteger brr[4];
            for (NSInteger i = 0; i < [transArr count]; i++) {
                brr[i] = [[transArr objectAtIndex:i] integerValue];
            }
            
            
            NSLog(@"随机数：%d  %d  %d  %d", arr[0], arr[1], arr[2], arr[3]);
            NSLog(@"序列化随机数：%d  %d  %d  %d", brr[0], brr[1], brr[2], brr[3]);
            NSLog(@"-----------------------");
            
            NSString *crc = [UtilityClass getVertifyCode:_no encryptLongitude:_cx encryptLatitude:_cy systemTime:ct tranArray:transArr];
            NSLog(@"随机序列生成校验码crc = %@", crc);
        
            
            NSString *_ct = [NSString stringWithFormat:@"%@.%d%d%d", ct, arr[0], arr[1], arr[2]];
            NSLog(@"_rt = %@", _ct);
            NSString *_idc= [NSString stringWithFormat:@"%d%@", arr[3], crc];
            NSLog(@"_idc = %@", _idc);
            
            NSURL *url = [NSURL URLWithString:strConfigUrl];
            NSLog(@"url123 = %@", url);
            
            //检查配置文件是否升级
            
            ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
            request.delegate = self;
            [request setRequestMethod:@"POST"];
            [request setAllowCompressedResponse:NO];
            
            [request setPostValue: _no forKey:@"no"];
            [request setPostValue: _cx forKey:@"cx"];
            [request setPostValue: _cy forKey:@"cy"];
            [request setPostValue: _ct forKey:@"ct"];
            [request setPostValue: _idc forKey:@"idc"];
            [request setTimeOutSeconds:1000];
            [request startAsynchronous]; //异步执行
            [request release];
            
        }
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    NSAssert(data, @"Check config request: receive data is nil.");
    
    NSLog(@"----xml = %@", [UtilityClass DataToUTF8String:data]);
    
    
    
    TBXML *tbxml = [TBXML tbxmlWithXMLData:data error:nil];
    
    TBXMLElement * root = tbxml.rootXMLElement;
	
	if (root) {
        
        NSString *strReturnCode = @"";
        NSString *strMsg = @"";
        
		TBXMLElement *return_info = [TBXML childElementNamed:@"return-info" parentElement:root];
        if (return_info) {
            
            TBXMLElement *return_code = [TBXML childElementNamed:@"return-code" parentElement:return_info];
            if (return_code) {
                strReturnCode = [TBXML textForElement:return_code];
                NSLog(@"=== strReturnCode = %@", strReturnCode);
            }
            
            TBXMLElement *msg = [TBXML childElementNamed:@"msg" parentElement:return_info];
            if (msg) {
                strMsg = [TBXML textForElement:msg];
                NSLog(@"=== strMsg = %@", strMsg);
            }
            if ([strReturnCode isEqualToString:@"1"]) {
                NSLog(@"%@", strMsg);
                //配置文件更新到本地沙盒
                [LLFileManage WritteToFile:data FileName:@"config.xml"];
            }else{
                NSLog(@"%@", strMsg);
            }

        }
    }
}

#pragma mark- 定时提交位置信息

//获得是否提交位置信息条件
- (void)getGPSCondition:(NSData *)data
{
    NSLog(@"获取是否提交位置信息条件");
    NSAssert(data, @"GPS Condition: local data is nil");
    
    TBXML *tbxml = [TBXML tbxmlWithXMLData:data error:nil];
    
    TBXMLElement * root = tbxml.rootXMLElement;

    NSString *strSendYear = @"";
    NSString *strSendMonth = @"";
    NSString *strSendTime = @"";  //时间段
    NSString *strTimeInterval = @""; //时间间隔
    NSString *strSendUrl = @"";
    
	if (root) {
        TBXMLElement *location = [TBXML childElementNamed:@"location" parentElement:root];
        if (location) {
            //年份
            TBXMLElement *sendYear = [TBXML childElementNamed:@"send-Year" parentElement:location];
            if (sendYear) {
                strSendYear = [TBXML textForElement:sendYear];
                NSLog(@"sendYear = %@", strSendYear);
            }
            //月份
            TBXMLElement *sendMonth = [TBXML childElementNamed:@"send-month" parentElement:location];
            if (sendMonth) {
                strSendMonth = [TBXML textForElement:sendMonth];
                NSLog(@"sendMonth = %@", strSendMonth);
            }
            //日期,当日是否提交
            TBXMLElement *sendDate = [TBXML childElementNamed:@"send-date" parentElement:location];
            if (sendDate) {
                NSString *strSendDate = [TBXML textForElement:sendDate];
                NSLog(@"sendDate = %@",strSendDate);
                
                //截取字符串保存数组
                NSArray *tmpArr = [[[NSArray alloc] init] autorelease];
                tmpArr  = [strSendDate componentsSeparatedByString:@","];
                NSLog(@"tmpArr = %@", tmpArr);
                self.gpsDateArr = [NSArray arrayWithArray:tmpArr];
                NSLog(@"self.gpsDateArr = %@", self.gpsDateArr);
                
            }
            //提交时间
            TBXMLElement *sendTime = [TBXML childElementNamed:@"send-time" parentElement:location];
            if (sendTime) {
                strSendTime = [TBXML textForElement:sendTime];
                NSLog(@"sendTime = %@",strSendTime);
            }
            //提交时间间隔
            TBXMLElement *timeInterval = [TBXML childElementNamed:@"time-interval" parentElement:location];
            if (timeInterval) {
                strTimeInterval = [TBXML textForElement:timeInterval];
                NSLog(@"timeInterval = %@", strTimeInterval);
            }
            
            //manual
            TBXMLElement *manual = [TBXML childElementNamed:@"manual" parentElement:location];
            if (manual) {
                NSString *strManual = [TBXML textForElement:manual];
                NSLog(@"manual = %@", strManual);
            }
            //send url
            TBXMLElement *sendUrl = [TBXML childElementNamed:@"send-url" parentElement:location];
            if (sendUrl) {
                NSString *strSendUrl = [TBXML textForElement:sendUrl];
                NSLog(@"sendUrl = %@", strSendUrl);
            }
            
            //判断是否提交
            BOOL isPostGPSInfo = [self isPostGPSInfo:strSendYear month:strSendMonth blDate:self.gpsDateArr];
            if (isPostGPSInfo) {
                NSLog(@"正式提交GPS信息!");
                
                NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }//location end!
    }//root end!
}

- (void)postGPSInfo
{
    NSString *no = [XMLHelper getNodeStr:@"mobile-no"];//self.tfPhoneNum.text;
    NSString *x = strLongitude; 
    NSString *y = strLatitude;
    NSString *z = [UtilityClass getSystemTime:@"yyyy-MM-dd HH:mm:ss"];//@"2009-12-25 01:37:12";
    
    NSLog(@"加密前：no = %@", no);
    NSLog(@"加密前：x = %@", x);
    NSLog(@"加密前：y = %@", y);
    NSLog(@"手机发送时间：z = %@", z);
    NSLog(@"------------------------");
    
    //数据加密
    NSString *_no = [PBEWithMD5AndDES encrypt:no password:nil];
    NSString *_x = [PBEWithMD5AndDES encrypt:x password:nil];
    NSString *_y = [PBEWithMD5AndDES encrypt:y password:nil];
    
    NSLog(@"加密后：_no = %@", _no);
    NSLog(@"加密后：_x = %@", _x);
    NSLog(@"加密后：_y = %@", _y);
    NSLog(@"手机发送时间：z = %@", z);
    NSLog(@"------------------------");  
    
    // 获取0-9之间4个不重复的随机数的数组  对象
    NSMutableArray *arans = [[[NSMutableArray alloc] initWithCapacity:4] autorelease]; 
    
    arans = [UtilityClass getRandArray:4];
    
    NSInteger arr[4];
    
    for (int i = 0; i < 4; i++) {
        //arr[i] = [UtilityClass getRandArray:4];
        //[arans addObject:[NSNumber numberWithInteger:arr[i]]];
        //NSNumber *num = [arans objectAtIndex:i];
        arr[i] = [[arans objectAtIndex:i] integerValue];
    }
    
    //随机数组序列化
    NSMutableArray *transArr = [[[NSMutableArray alloc] initWithCapacity:4] autorelease]; 
    
    transArr = [UtilityClass transArray:arans];
    
    
    //用于打印测试
    NSInteger brr[4];
    for (NSInteger i = 0; i < [transArr count]; i++) {
        brr[i] = [[transArr objectAtIndex:i] integerValue];
    }
    
    NSLog(@"随机数：%d  %d  %d  %d", arr[0], arr[1], arr[2], arr[3]);
    NSLog(@"序列化随机数：%d  %d  %d  %d", brr[0], brr[1], brr[2], brr[3]);
    NSLog(@"-----------------------");
    
    
    // 根据随机序列生成校验码
    NSString *crc = [UtilityClass getVertifyCode:_no encryptLongitude:_x encryptLatitude:_y systemTime:z tranArray:transArr];
    NSLog(@"随机序列生成校验码crc = %@", crc);
    
    //    // 手机发送的数据相当于以下
    //    NSString *postStr = [NSString stringWithFormat:@"no=%@&x=%@&y=%@&z=%@.%d%d%d&idc=%d%@", _no, _x, _y, z, arr[0], arr[1], arr[2], arr[3], crc];
    //    NSLog(@"手机发送信息：%@", postStr);
    //    NSLog(@"----------------------");
    
    
    /*!
     * 提交http请求
     */
    NSString *t_no = _no;
    NSString *t_x = _x;
    NSString *t_y = _y;
    NSString *t_z = [NSString stringWithFormat:@"%@.%d%d%d", z, arr[0], arr[1], arr[2]];
    NSString *t_idc = [NSString stringWithFormat:@"%d%@", arr[3], crc];
    
    
    NSURL *url = [NSURL URLWithString:@"http://konka.mymyty.com/GPSBack.do"];
    NSLog(@"url = %@", url);
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setRequestMethod:@"POST"];
    request.delegate = self;
    [request setAllowCompressedResponse:NO];
    
    [request setPostValue: t_no forKey:@"no"];
    [request setPostValue:t_x forKey:@"x"];
    [request setPostValue:t_y forKey:@"y"];
    [request setPostValue:t_z forKey:@"z"];
    [request setPostValue:t_idc forKey:@"idc"];
    [request setTimeOutSeconds:1000];
    [request startAsynchronous]; //异步执行
    [request release];
    
    /*!
     * 解密过程 测试加密算法
     */ 
#ifdef LL_DEBUG
    
    
    
    // 1.核对校验码
    if ([UtilityClass checkVerifyCode:t_no encryptLongitude:t_x encryptLatitude:t_y systemTime:t_z idcStr:t_idc]) {
        // 2.解密数据
        NSLog(@"通过校验！");
        
        NSString *str1 = [PBEWithMD5AndDES decrypt:t_no password:nil];
        NSString *str2 = [PBEWithMD5AndDES decrypt:t_x password:nil];
        NSString *str3 = [PBEWithMD5AndDES decrypt:t_y password:nil];
        
        NSLog(@"===str1 = %@", str1);
        NSLog(@"===str2 = %@", str2);
        NSLog(@"===str3 = %@", str3);
        
        
    } else {
        // 违法数据拒绝处理
        NSLog(@"没有通过校验！");
    }
#endif
    
}

//判断是否定时提交位置信息
- (BOOL)isPostGPSInfo:(NSString *)strYear month:(NSString *)strMonth blDate:(NSArray *)dateArr
{
    //拼接时间
    NSString *theDate = @"";
    if ([strMonth length] == 1) {
         theDate = [NSString stringWithFormat:@"%@-0%@", strYear, strMonth];
    }else if ([strMonth length] == 2){
         theDate = [NSString stringWithFormat:@"%@-%@", strYear, strMonth];
    }
    NSLog(@"theDate = %@", theDate);
    //获取系统当前日期
    NSString *nowDate = [UtilityClass getSystemTime:@"yy-MM"];
    NSLog(@"nowDate = %@", nowDate);
    
    NSInteger intToday = [[UtilityClass getSystemTime:@"dd"] integerValue];
    NSLog(@"intToday = %d", intToday);
    
    if ([nowDate isEqualToString:theDate] && [[dateArr objectAtIndex:intToday - 1] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

//定时提交位置信息
- (void)getGPSInfo
{
    NSLog(@"定时提交位置信息");
    
    //获取定位信息
    CLLocationManager *_lm = [[CLLocationManager alloc] init];  
    self.lm = _lm;
    //是否开启定位服务
    if ([self.lm locationServicesEnabled]) {  
        self.lm.delegate = self;  
        //精确度
        self.lm.desiredAccuracy = kCLLocationAccuracyBest;
        //指定设备必须移动多少距离位置信息才会更新，这个属性的单位是米,可以使用kCLDistanceFilterNone常量
        self.lm.distanceFilter = 10.0f;
        //启动位置管理器
        [self.lm startUpdatingLocation];  
    } 
    [_lm release];
}

#pragma mark- 定位服务

//获得一个新的定位值时
- (void) locationManager: (CLLocationManager *) manager  
     didUpdateToLocation: (CLLocation *) newLocation  
            fromLocation: (CLLocation *) oldLocation{  
    NSString *lat = [NSString stringWithFormat:@"%f",  
                     newLocation.coordinate.latitude];  
    //纬度
    strLatitude = lat;  
    
    NSString *lng = [NSString stringWithFormat:@"%f",  
                     newLocation.coordinate.longitude];
    //经度
    strLongitude = lng;  
    
    
    //horizontalAccuracy属性可以指定精度范围，单位是米
    NSString *acc = [NSString stringWithFormat:@"%f",  
                     newLocation.horizontalAccuracy];  
    strAccuracy = acc; //精确度     
}  

//位置管理器不能确定位置信息
- (void) locationManager: (CLLocationManager *) manager  
        didFailWithError: (NSError *) error {  
    NSString *msg = @"Error obtaining location";  
    UIAlertView *alert = [[UIAlertView alloc]  
                          initWithTitle:@"Error"  
                          message:msg  
                          delegate:nil  
                          cancelButtonTitle: @"Done"  
                          otherButtonTitles:nil];  
    [alert show];       
    [alert release];  
}  

@end
