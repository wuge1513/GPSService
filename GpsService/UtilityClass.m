//
//  UtilityClass.m
//  GpsService
//
//  Created by LiuLei on 12-2-27.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import "UtilityClass.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+CRC32.h"
#import "XMLHelper.h"

@implementation UtilityClass

static const NSInteger LOCAL_RAND_MAX = 10;

/**
 *获取格式化系统时间
 * @param  timeFormat 输出系统时间格式 yyyy-MM-dd HH:mm:ss.SSS 可以精确到毫秒
 */
+ (NSString *)getSystemTime:(NSString *)timeFormatStr{
    
    NSString *_curTime = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:timeFormatStr];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];//精确到毫秒
    //NSLog(@"Date%@", [dateFormatter stringFromDate:[NSDate date]]);
    _curTime = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];

    return _curTime;

}

/**
 * 校验随机数是否已存在
 * @param muArray数组内存放NSNumber数据
 * @param num 生成的随机数
 */
+ (BOOL)checkNum:(NSMutableArray *)muArray randNum:(NSInteger)num{
    for (int i = 0; i < [muArray count]; i++) {
        if ([NSNumber numberWithInteger:num] == [muArray objectAtIndex:i])
            return false;
    }
    return true;
}

#pragma mark-
#pragma mark-取得随机数数组
/**
 * 获取N个不重复的随机数 封装成NSNumber类型存入数组 
 * @param count 生成随机数个数
 */
+ (NSMutableArray *)getRandArray:(NSInteger)count{
    
    NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:count];
    NSInteger i = 0;
    while (i < count) { 
        NSInteger num = arc4random()%LOCAL_RAND_MAX;
        if ([self checkNum:muArray randNum:num]) {
            [muArray addObject:[NSNumber numberWithInteger:num]];
            i++;
            //NSLog(@"随机数===%d",num);
        }
    }
    return muArray;
}

#pragma mark-
#pragma mark-数组转换成序列
/**随机数转换成序列
 * @param  muArray 随机数数组,NSNumber对象
 * @return 序列化后的随机数组,NSNUmber对象
 */
+ (NSMutableArray *)transArray:(NSMutableArray *)muArray{
    
    NSMutableArray *trArr = [NSMutableArray arrayWithCapacity:1];
    
    for (NSInteger i = 0; i < [muArray count]; i++) {
        [trArr addObject:[NSNull null]];
    }
    
    NSInteger index = 0;
    NSInteger len = 0;
    NSNumber *num = [NSNumber numberWithInteger:LOCAL_RAND_MAX];
    NSNumber *numTmp;
    
    while (len < [muArray count]) {
        for (NSInteger i = 0; i < [muArray count]; i++) {
            numTmp = [muArray objectAtIndex:i];
            if ([trArr objectAtIndex:i] == [NSNull null] && numTmp.integerValue < num.integerValue) {
                num = [muArray objectAtIndex:i];
                index = i;
            }
        }
        [trArr replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:len]];
        len++;
        num = [NSNumber numberWithInteger:LOCAL_RAND_MAX];
    } 
//    for (NSInteger i = 0; i < [muArray count]; i++) {
//        NSNumber *x = [trArr objectAtIndex:i];
//        NSLog(@"随机数序列化=== %d", x.integerValue);
//    }
    return trArr;
}

+ (NSData*) hexStrToBytes:(NSString*)strHex {
	NSMutableData* data = [[[NSMutableData alloc] init] autorelease];
	int idx;
	for (idx = 0; idx+2 <= strHex.length; idx+=2) {
		NSRange range = NSMakeRange(idx, 2);
		NSString* hexStr = [strHex substringWithRange:range];
		NSScanner* scanner = [NSScanner scannerWithString:hexStr];
		unsigned int intValue;
		[scanner scanHexInt:&intValue];
		[data appendBytes:&intValue length:1];
	}
    //NSLog(@"hexStrToBytes=== %@", data);
	return data;
}


+ (NSString *)bytesToHexStr:(NSData *)data
{
    NSMutableString *hexStr = [NSMutableString string];
    unsigned char *bytes = (unsigned char *)[data bytes];
    
    char temp[3];
    int i = 0;
    
    for (i = 0; i < [data length]; i++) {
        temp[0] = temp[1] = temp[2] = 0;
        (void)sprintf(temp, "%02x", bytes[i]);
        [hexStr appendString:[NSString stringWithUTF8String:temp]];
    }
    return hexStr;
}


+ (NSString *)getCRC32Code:(NSString *)srcString{

    NSData *data = [self UTF8StringToData:srcString];
    
    NSString *crcCode = [NSData CRC32:data];
    NSLog(@"crcCode ===== %@", crcCode);
    
    NSString *fillStr = @"00000000";
    NSString *crcStr = [NSString stringWithFormat:@"%@%@", [fillStr substringFromIndex:[crcCode length]], crcCode];
    return crcStr;
}


/**
 * 获取校验码 
 *@param no 加密的手机号码
 *@param encryptLongitude 加密后的经度
 *@param encryptLatitude 加密的纬度
 *@param systemTime 手机时间不加密，格式如 yyyy-MM-dd HH:mm:ss
 *@param tranArray 加密的手机号码
 */

+ (NSString *)getVertifyCode:(NSString *)no 
            encryptLongitude:(NSString *)x 
             encryptLatitude:(NSString *)y 
                  systemTime:(NSString *)z 
                     tranArray:(NSMutableArray *)tranArray{
    
    NSArray *arrs = [NSArray arrayWithObjects:no, x, y, z, nil];
    NSString *stringBuffer = @"";

    //通过随机数拼接字符串
    for (NSInteger i = 0; i < [tranArray count]; i++) {
        //NSNumber => NSInteger
        NSInteger index = [[tranArray objectAtIndex:i] integerValue];
        //拼接字符串
       stringBuffer = [stringBuffer stringByAppendingString:[arrs objectAtIndex:index]];
    }
    return [self getCRC32Code:stringBuffer];
}


/**
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
                 idcStr:(NSString *)idc{

    if (z.length != 23 || idc.length != 9)
        return false;

    NSString *randStr1 = [z substringFromIndex:20];
    NSString *randStr2 = [idc substringWithRange:NSMakeRange(0, 1)];
    NSString *randStr = [randStr1 stringByAppendingString:randStr2];
    NSString *crc = [idc substringFromIndex:1];
    
    NSMutableArray *trArray = [NSMutableArray arrayWithCapacity:randStr.length];
    
    NSInteger aa[randStr.length];
    for (NSInteger i = 0; i < randStr.length; i++) {
        aa[i] = [randStr substringWithRange:NSMakeRange(i, 1)].integerValue;
        //NSLog(@"%d",aa[i]);
        [trArray addObject:[NSNumber numberWithInteger:aa[i]]];
    }
    
    //转换成序列
    NSMutableArray *tranArray = [NSMutableArray arrayWithArray: [self transArray:trArray]];
    
    if ([crc isEqualToString:[self getVertifyCode:no encryptLongitude:x encryptLatitude:y systemTime:[z substringToIndex:19] tranArray:tranArray]]) {
        
        return true;
    }else{
        return false;
    }
}


+ (NSString*) DataToASCIIString:(NSData*)data{
	return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

+ (NSData*) ASCIIStringToData:(NSString*)str{
	return [str dataUsingEncoding:NSASCIIStringEncoding];
}

+ (NSString*) DataToUTF8String:(NSData*)data{
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSData*) UTF8StringToData:(NSString*)str{
	return [str dataUsingEncoding:NSUTF8StringEncoding];
}


#pragma mark-
#pragma mark- MD5校验
//add by liulei

/*!
 * 获取MD5校验码
 * @param C 字符串
 */
+ (NSString *)md5DigestCString:(const char *)str
{
    const char *cStr = str;//[str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

/*!
 * 获取MD5校验码
 * @param NSString字符串对象
 */
+ (NSString *)md5Digest:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

#pragma mark- 定时通知


/*!
 * 获取定时时间增量
 * @param strHour  时间  HH:mm
 * @return 定时时间与系统时间增量
 */
+ (NSInteger)getTimeInterval:(NSString *)strTime
{
    NSArray *arr = [[[NSArray alloc] init] autorelease];
    arr = [strTime componentsSeparatedByString:@":"];

    return [self getTimeInterval:[arr objectAtIndex:0] strMin:[arr objectAtIndex:1]];
}

/*!
 * 获取定时时间增量
 * @param strHour  小时字符串
 * @param strHour  分钟字符串
 * @return 定时时间与系统时间增量
 */
+ (NSInteger)getTimeInterval:(NSString *)strHour strMin:(NSString *)strMinute{
    NSLog(@"获取定时时间增量");
    
    NSDate* nowDate = [NSDate date];
	
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
	
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	dateComps = [calendar components:unitFlags fromDate:nowDate];
	
    NSInteger nowHour = [dateComps hour];
	NSInteger nowMin = [dateComps minute];
	NSInteger nowSec = [dateComps second]; 
	
	NSLog(@"定时时间 = %d时,%d分,%d秒",nowHour,nowMin,nowSec);
    
	NSInteger htime1= [strHour integerValue];
	NSInteger mtime1= [strMinute integerValue];
    
	NSInteger hs = htime1 - nowHour;
	NSInteger ms = mtime1 - nowMin;
	
	if(ms<0){
		ms=ms+60;
		hs=hs-1;
	}
	if(hs<0){
		hs=hs+24;
		hs=hs-1;
	}
	if (ms<=0&&hs<=0){
		hs=24;
		ms=0;
        NSLog(@"第二天！");
	}
	
    
	NSInteger hm = (hs * 3600 ) + (ms * 60) - nowSec;
    
    return hm;
}


+ (void)postLocalNotification:(NSString *)startTime blStr:(NSString *)str;
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//-----获取闹钟数据---------------------------------------------------------
	
	NSString *clockTime = startTime;
    NSLog(@"clockTime = %@", clockTime);
    
	NSString *clockMode = str;
    NSLog(@"clockMode = %@", clockMode);
    
	NSString *clockMusic = @"布谷鸟";
    NSLog(@"clockMusic = %@", clockMusic);
    
	NSString *clockRemember = @"笨蛋，笨蛋！";//[clockDictionary objectForKey:@"ClockRemember"];
    NSLog(@"clockRemember = %@", clockRemember);
    
	//-----组建本地通知的fireDate-----------------------------------------------
	
	NSArray *clockTimeArray = [clockTime componentsSeparatedByString:@":"];
	NSDate *dateNow = [NSDate date];
	NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
	//[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //[comps setTimeZone:[NSTimeZone timeZoneWithName:@"CMT"]];
	NSInteger unitFlags = NSEraCalendarUnit | 
	NSYearCalendarUnit | 
	NSMonthCalendarUnit | 
	NSDayCalendarUnit | 
	NSHourCalendarUnit | 
	NSMinuteCalendarUnit | 
	NSSecondCalendarUnit | 
	//NSWeekCalendarUnit | 
	NSWeekdayCalendarUnit;// | 
	///NSWeekdayOrdinalCalendarUnit | 
	//NSQuarterCalendarUnit;
	
	comps = [calendar components:unitFlags fromDate:dateNow];
	[comps setHour:[[clockTimeArray objectAtIndex:0] intValue]];
	[comps setMinute:[[clockTimeArray objectAtIndex:1] intValue]];
	[comps setSecond:0];
	
	//------------------------------------------------------------------------
    NSInteger weekday = [comps day];
    NSLog(@"weekday = %d", weekday);
    
    NSArray *array = [clockMode componentsSeparatedByString:@","];
    NSLog(@"array = %@", array);

    
	NSInteger count = [array count];
    //选中的星期
    NSInteger clockDays[count];
	
    NSInteger blNum = 0;
	//查找设定的周期模式
	for (NSInteger i = 0; i < count; i++) {

        if ([[array objectAtIndex:i] isEqualToString:@"1"]) {
            clockDays[blNum] = i + 1;
            NSLog(@"== clockDays[%d] = %d", blNum, clockDays[blNum]);
            blNum++;
        }
	}
	
	NSInteger days = 0;
	NSInteger temp = 0;
    
	for (NSInteger i = 0; i < blNum; i++) {
	    temp = clockDays[i] - weekday;//处理日期的循环
		days = (temp >= 0 ? temp : temp + count);
        
		NSDate *newFireDate = [[calendar dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
		
		UILocalNotification *newNotification = [[UILocalNotification alloc] init];
		if (newNotification) {
			newNotification.fireDate = newFireDate;
			newNotification.alertBody = clockRemember;
			newNotification.soundName = clockMusic;
			newNotification.alertAction = @"提交位置信息";
			//newNotification.repeatInterval = kCFCalendarUnitDay; //NSWeekCalendarUnit;
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"123"forKey:@"ActivityClock"];
			newNotification.userInfo = userInfo;
			[[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
		}
		NSLog(@"Post new localNotification:%@", [newNotification fireDate]);
		[newNotification release];
		
	}
	[pool release];
}

/*!
 * 设置闹铃
 * @param timeInterval  时间增量
 * @param strAlert  闹铃通知内容
 */

+ (void)setAlarm:(NSInteger)timeInterval Alert:(NSString *)strAlert 
{
   // NSLog(@"1 = %d", timeInterval);
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;//应用程序右上角的数字=0（消失）   
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];//取消所有的通知  
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) 
    {		
        NSDate *now=[NSDate new];
        notification.fireDate = [now dateByAddingTimeInterval:timeInterval];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        //notification.repeatInterval = NSWeekCalendarUnit;//一周提示一次
        //notification.repeatInterval = kCFCalendarUnitDay; //每天一次kCFCalendarUnitDay  NSDayCalendarUnit

        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = strAlert;
        notification.applicationIconBadgeNumber++; 	
        NSDictionary *userinfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt: 123], @"test",nil];
        notification.userInfo = userinfo;
        
        //NSString *strSendYear = @"2012";//= [XMLHelper getNodeStr:<#(NSString *)#> secondNode:<#(NSString *)#>];
        //NSString *strSendMonth = @"4";
        
        NSString *strSendDate = [XMLHelper getNodeStr:@"location" secondNode:@"send-date"];

        //截取字符串保存数组
        NSArray *tmpArr = [[[NSArray alloc] init] autorelease];
        tmpArr  = [strSendDate componentsSeparatedByString:@","];
        NSLog(@"tmpArr = %@", tmpArr);
        
        notification.fireDate = [now dateByAddingTimeInterval:timeInterval];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        //BOOL isPostGPSInfo = NO;
        for (int i = 7; i < [tmpArr count]; i++) {
            
            if ([[tmpArr objectAtIndex:i] isEqualToString:@"1"]) {
                NSLog(@"===date = %d", i + 1);
                timeInterval += 24*60*60;
                 notification.fireDate = [now dateByAddingTimeInterval:timeInterval];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }else{
                timeInterval += 24*60*60;
                notification.fireDate = [now dateByAddingTimeInterval:timeInterval];
            }
            
        }

    }
    [notification release];
}

//判断是否定时提交位置信息
+ (BOOL)isPostGPSInfo:(NSString *)strYear month:(NSString *)strMonth strDate:(NSString *)strDate
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
    NSString *nowDate = [UtilityClass getSystemTime:@"yyyy-MM"];
    NSLog(@"nowDate = %@", nowDate);
    
    NSInteger intToday = [[UtilityClass getSystemTime:@"dd"] integerValue];
    NSLog(@"intToday = %d", intToday);
    
    if ([nowDate isEqualToString:theDate] && [strDate isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

//判断是否定时提交位置信息
+ (BOOL)isPostGPSInfo:(NSString *)strYear month:(NSString *)strMonth blDate:(NSArray *)dateArr
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
    NSString *nowDate = [UtilityClass getSystemTime:@"yyyy-MM"];
    NSLog(@"nowDate = %@", nowDate);
    
    NSInteger intToday = [[UtilityClass getSystemTime:@"dd"] integerValue];
    NSLog(@"intToday = %d", intToday);
    
    if ([nowDate isEqualToString:theDate] && [[dateArr objectAtIndex:intToday - 1] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

@end



