//
//  LLFileManage.h
//  GpsService
//
//  Created by LiuLei on 12/3/10.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import "LLFileManage.h"


@implementation LLFileManage

- (id)init{
	
	self = [super init];
	if (self != nil) {
	}
	return self;
}

-(void) dealloc{
	[super dealloc];
}


#pragma mark- 沙盒文件管理

/*! 
 * 创建路径
 * @param fileName 文件名
 * @return 返回文件完整路径
 */
+ (NSString *) createFilePath:(NSString *)fileName
{
    //沙盒主文件夹
	NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectiory = [storeFilePath objectAtIndex:0];
	return [docDirectiory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
	
    //沙盒Temp文件夹
    //NSString *tempPath = NSTemporaryDirectory();
	//return [tempPath stringByAppendingPathComponent:fileName];
}

/*!
 * 判断文件是否存在
 * @param fileName 文件名
 */
+ (BOOL)fileIsExist:(NSString *)fileName
{
    NSString *tempFilePath = [self createFilePath:fileName];
    BOOL blExist = [[NSFileManager defaultManager] fileExistsAtPath:tempFilePath];
    
    if (blExist) {
        NSLog(@"文件存在！");
        return YES;
    }else {//加载
        NSLog(@"文件不存在！");
        return NO;
    }
}


/*!
 * 存储文件
 * @param fileName 文件名
 */
+ (void)WritteToFile:(NSData *)sender FileName:(NSString *)fileName{
	
    NSMutableArray *fileNameArray = [[NSMutableArray alloc] initWithCapacity:1];
	[fileNameArray addObject:fileName];
	
	NSData *data = sender;
	
	NSMutableData *rootData = [[NSMutableData alloc] init];
	
	//接收服务器传递的文件，放入data
	[rootData appendData:data];
	
	//然后将数据写入本地文件中
	[rootData writeToFile:[self createFilePath:fileName] atomically:NO];
	
	[rootData release];
    [fileNameArray release];
}


/*!
 * 读取文件
 * @param fileName 文件名称
 *
 */
+ (NSData *)ReadFromFile:(NSString *)fileName{
	
	NSString *tmpFilePath = [self createFilePath:fileName];
	
    //NSData *data;
	if ( [[NSFileManager defaultManager] fileExistsAtPath:tmpFilePath ]) {
		return [[[NSData alloc] initWithContentsOfFile:tmpFilePath] autorelease];
	}
    
	return nil;
}

/*!
 * 删除文件
 * @param fileName 文件名
 */
+ (void)DeleteFile:(NSString *)fileName{
		
    BOOL blExist= [self fileIsExist:fileName];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if (!blExist) {
        NSLog(@"不存在！");
        return ;
    }else {
        NSLog(@"存在！");
        BOOL blDele= [fileManager removeItemAtPath:[self createFilePath:fileName] error:nil];
        if (blDele) {
            NSLog(@"删除成功！");
        }else {
            NSLog(@"删除失败！");
        }
    }
}



#pragma mark- 程序包内资源

/*!
 * 加载资源包内文件
 * @param fileName 文件名
 * @param type  文件类型，扩展名
 */

+ (NSData *)ReadLocalFile:(NSString *)fileName FileType:(NSString *)type
{
    
    NSString *localFile = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:localFile];
    return data;
}


@end
