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
    NSLog(@"001");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"002");
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    NSDate* now = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	comps = [calendar components:unitFlags fromDate:now];
	int hour = [comps hour];
	int min = [comps minute];
	int sec = [comps second]; 
	
	NSLog(@"%d,%d,%d",hour,min,sec);
    
	int htime1 = 16;
	int mtime1 = 15;
    
	int hs=htime1-hour;
	int ms=mtime1-min;
	NSString *start=[[NSString alloc]init];
	start=@"今天的";
	NSString *over=[[NSString alloc]init];
	over=@"今天的";
	
	if(ms<0)
	{
		ms=ms+60;
		hs=hs-1;
	}
	if(hs<0)
	{
		hs=hs+24;
		hs=hs-1;
		
		
	}
	if (ms<=0&&hs<=0) {
		hs=24;
		ms=0;
		over=@"明天的";
	}
	
    
    NSString *str = [NSString stringWithFormat:@"你设置的时间：%@ %i:%i TO %@ %i:%i",start,hour,min,over,htime1,mtime1];
    NSLog(@"===str1 = %@", str);
	
	int hm=(hs*3600)+(ms*60)-sec;
	UILocalNotification *notification=[[UILocalNotification alloc] init];
	if (notification!=nil) 
	{
        
		NSDate *now=[NSDate new];
		notification.fireDate=[now addTimeInterval:hm];
        //notification.repeatInterval = [];
		NSLog(@"%d",hm);
		notification.timeZone=[NSTimeZone defaultTimeZone];
		notification.soundName = @"ping.caf";
		//notification.alertBody=@"TIME！";
		
        
		notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"你设置的时间是：%i ： %i .",nil),htime1,mtime1];
        
		
		[[UIApplication sharedApplication]   scheduleLocalNotification:notification];
		
		
	}
	[over release];
	[start release];
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"003");
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"004");
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"005");
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
