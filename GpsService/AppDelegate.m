//
//  AppDelegate.m
//  GpsService
//
//  Created by LiuLei on 12-2-25.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"

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

//启动检查配置更新
- (void)checkUpConfig
{
    NSLog(@"启动检查配置更新");
}

@end
