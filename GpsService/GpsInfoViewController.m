//
//  GpsInfoViewController.m
//  GpsService
//
//  Created by LiuLei on 12-2-25.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import "GpsInfoViewController.h"

#import "UtilityClass.h"
#import "PBEWithMD5AndDES.h"
#import "SBJson.h"
//ASIHttpRequest
#import "ASIFormDataRequest.h"
@implementation GpsInfoViewController
@synthesize latitudeTextField, longitudeTextField, accuracyTextField;  
@synthesize lm; 
@synthesize tfLocationWay, tfLocationTime, tfPhoneNum;

- (void)dealloc{
    [tfLocationWay release];
    [tfLocationTime release];
    [tfPhoneNum release];
    [latitudeTextField release];
    [longitudeTextField release];
    [accuracyTextField release];
    [super release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"定位信息", nil);
        
        //默认返回按钮
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(actionBack)];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        [leftButtonItem release];
        
        //默认确认按钮
        UIBarButtonItem *selectButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleBordered target:self action:@selector(actionConfirm)];
        self.navigationItem.rightBarButtonItem = selectButtonItem;
        [selectButtonItem release];
    }
    return self;
}

- (void)getLocationInfo{

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
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
    

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//返回
- (void)actionBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-
#pragma mark-上传位置信息
//确认
- (void)actionConfirm
{
    NSString *no = self.tfPhoneNum.text;
    NSString *x = self.longitudeTextField.text; 
    NSString *y = self.latitudeTextField.text; 
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

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    NSAssert(data, @"GPS info request: data is nil");
    
    NSLog(@"json = %@", [UtilityClass DataToUTF8String:data]);
    
    NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@", resDic);
    NSString *resultCode = [resDic objectForKey:@"status"];
    NSLog(@"resultCode = %@", resultCode);
    
    NSString *strResult;
    if ([resultCode isEqualToString:@"1"]) {
        strResult = @"上传成功！";
    }else{
        strResult = @"上传失败！";
    }
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
//                                                    message:strResult 
//                                                   delegate:self 
//                                          cancelButtonTitle:@"确定" 
//                                          otherButtonTitles:nil, nil];
//    
//    [alert show];
//    [alert release];
//    return;
}

#pragma mark-
#pragma mark-定位服务

//获得一个新的定位值时
- (void) locationManager: (CLLocationManager *) manager  
     didUpdateToLocation: (CLLocation *) newLocation  
            fromLocation: (CLLocation *) oldLocation{  
    NSString *lat = [[NSString alloc] initWithFormat:@"%f",  
                     newLocation.coordinate.latitude];  
    //纬度
    latitudeTextField.text = lat;  
    
    NSString *lng = [[NSString alloc] initWithFormat:@"%f",  
                     newLocation.coordinate.longitude];
    //精度
    longitudeTextField.text = lng;  
    
    
    //horizontalAccuracy属性可以指定精度范围，单位是米
    NSString *acc = [[NSString alloc] initWithFormat:@"%f",  
                     newLocation.horizontalAccuracy];  
    accuracyTextField.text = acc;      
    
    [acc release];  
    [lat release];  
    [lng release]; 
    
    self.tfLocationWay.text = @"GPS";
    
}  

//位置管理器不能确定位置信息
- (void) locationManager: (CLLocationManager *) manager  
        didFailWithError: (NSError *) error {  
    NSString *msg = [[NSString alloc]  
                     initWithString:@"Error obtaining location"];  
    UIAlertView *alert = [[UIAlertView alloc]  
                          initWithTitle:@"Error"  
                          message:msg  
                          delegate:nil  
                          cancelButtonTitle: @"Done"  
                          otherButtonTitles:nil];  
    [alert show];      
    [msg release];  
    [alert release];  
}  


@end
