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
#import "ASIFormDataRequest.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"000");
    
    //启动检查配置更新
    [self checkUpConfig];
    
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

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"002 app will enter Background");
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */

    UILocalNotification *notification = [[UILocalNotification alloc] init];
	if (notification) 
	{		
		NSDate *now=[NSDate new];
		notification.fireDate = [now dateByAddingTimeInterval:10];
		notification.timeZone = [NSTimeZone defaultTimeZone];
		notification.soundName = @"ping.caf";
		notification.alertBody = @"hello,hello";
		NSDictionary *userinfo = [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSNumber numberWithInt: 123], @"test",nil];
		notification.userInfo = userinfo;
		[[UIApplication sharedApplication] scheduleLocalNotification:notification];
		
	}
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

    NSLog(@"003 app will enter foreground");
    [self actionAPP];
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

//测试
- (void)actionAPP{
    NSLog(@"12345678");
    
}

#pragma mark- 检查配置文件更新
//启动检查配置更新
- (void)checkUpConfig
{
    NSLog(@"启动检查配置更新");
    //判断配置文件是否已经下载
    NSString *fileName = @"config.xml";
    BOOL fileIsExist = [LLFileManage fileIsExist:fileName];
    if (fileIsExist) {
        NSLog(@"已经下载到本地");
        NSData *data = [LLFileManage ReadFromFile:fileName];
        //NSLog(@"data1==%@", data);
        [self getHostStr:data];
    }else{        
        NSData *data = [LLFileManage ReadLocalFile:@"config" FileType:@"xml"];
        //NSLog(@"data2==%@", data);
        [self getHostStr:data];
    }
}


//获得App当前版本号
- (void)getHostStr:(NSData *)data
{
    NSAssert(data, @"Check update: local file is nil");
    
    TBXML *tbxml = [TBXML tbxmlWithXMLData:data error:nil];
    
    TBXMLElement * root = tbxml.rootXMLElement;
	
	if (root) {
        
        NSString *strVersion = @"";
        NSString *strConfigUrl = @"";
        NSString *strTime = @"";
        
        TBXMLElement *config_update = [TBXML childElementNamed:@"config-update" parentElement:root];
        if (config_update) {
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
            }
            
            
            
            NSString *no = @"18801167317";   //手机号码
            NSString *cx = @"";
            NSString *cy = @"";
            NSString *ct = [UtilityClass getSystemTime:@"yyyy-MM-dd HH:mm:ss"];     //手机时间 （安全校验用）
            
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
            
            NSString *crc = [UtilityClass getVertifyCode:no encryptLongitude:cx encryptLatitude:cy systemTime:ct tranArray:transArr];
            NSLog(@"随机序列生成校验码crc = %@", crc);
            
            NSString *_ct = [NSString stringWithFormat:@"%@.%d%d%d", ct, arr[0], arr[1], arr[2]];
            NSLog(@"_rt = %@", _ct);
            NSString *_idc= [NSString stringWithFormat:@"%d%@", arr[3], crc];
            NSLog(@"_idc = %@", _idc);
            
            NSURL *url = [NSURL URLWithString:@"http://konka.mymyty.com/GPSBack.do"];
            NSLog(@"url = %@", url);
            
            //检查配置文件是否升级
            NSMutableDictionary *postData = [NSMutableDictionary dictionaryWithCapacity:5];
            [postData setValue:no forKey:@"no"];
            [postData setValue:cx forKey:@"cx"];
            [postData setValue:cy forKey:@"cy"];
            [postData setValue:_ct forKey:@"ct"];
            [postData setValue:_idc forKey:@"idc"];
            
            ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
            [request setRequestMethod:@"POST"];
            request.delegate = self;
            [request setPostValue:postData forKey:@"http://konka.mymyty.com/GPSBack.do"];
            [request setTimeOutSeconds:1200];
            [request startAsynchronous]; //异步执行
            [request release];
            
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"Response %d ==> %@, =>%@", request.responseStatusCode, [request responseStatusMessage], [request responseString]);
    
    
    NSLog(@"responeseData ==== %@", [request responseData]);
    NSLog(@"xxx = %@", request);
    
    NSData *response = [request responseData];
    
    //[LLFileManage WritteToFile:response FileName:@"config.xml"];
    NSLog(@"response = %@ ", response);
    
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(NSUTF8StringEncoding);//kCFStringEncodingGB_18030_2000
    NSString *retStr = [[[NSString alloc] initWithData:response encoding:enc] autorelease];
    NSLog(@"retstr = %@", retStr);

}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    //NSLog(@"data123 = %@", data);
    NSLog(@"456= %@", [UtilityClass DataToUTF8String:data]);
}

@end
