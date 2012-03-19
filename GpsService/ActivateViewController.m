//
//  DetailViewController.m
//  GpsService
//
//  Created by LiuLei on 12-2-25.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import "ActivateViewController.h"
#import "Config.h"
#import "UtilityClass.h"
#import "PBEWithMD5AndDES.h"
#import "LLFileManage.h"
//ASIHttpRequest
#import "ASIFormDataRequest.h"
#import "TBXML.h"
#import "SBJson.h"


//static NSString *strHost;

@implementation ActivateViewController

//@synthesize lblCompanyNum, tfCompanyNum;
@synthesize lblPhoneNum, lblPersonNum;
@synthesize tfPhoneNum, tfPersonNum;  
@synthesize strHost;

@synthesize webData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"身份确认";//NSLocalizedString(@"Detail", @"Detail");
    
        //默认返回按钮
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(actionBack)];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        [leftButtonItem release];
        
        //默认确认按钮
        UIBarButtonItem *selectButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleBordered target:self action:@selector(actionConfirm)];
        self.navigationItem.rightBarButtonItem = selectButtonItem;
        [selectButtonItem release];
    }
    return self;
}

- (void)dealloc
{
    [strHost release];
    [lblPhoneNum release];
    //[lblCompanyNum release];
    [lblPersonNum release];
    
    [tfPhoneNum release];
    //[tfCompanyNum release];
    [tfPersonNum release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    //手机号标签
    UILabel *_lblPhoneNum = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 60.0, 100.0, 30.0)];
    self.lblPhoneNum = _lblPhoneNum;
    self.lblPhoneNum.text = @"确认手机号";
    self.lblPhoneNum.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.lblPhoneNum];
    [_lblPhoneNum release];
    
    //公司确认码
//    UILabel *_lblCompanyNum = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 100.0, 100.0, 30.0)];
//    self.lblCompanyNum = _lblCompanyNum;
//    self.lblCompanyNum.text = @"公司确认码";
//    self.lblCompanyNum.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.lblCompanyNum];
//    [_lblCompanyNum release];
    
    //个人确认码
    UILabel *_lblPersonNum = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 120.0, 100.0, 30.0)];
    self.lblPersonNum = _lblPersonNum;
    self.lblPersonNum.text = @"个人确认码";
    self.lblPersonNum.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.lblPersonNum];
    [_lblPersonNum release];
    
    //确认手机号输入框
    UITextField *_tfPhoneNum = [[UITextField alloc] initWithFrame:CGRectMake(110.0, 60.0, 200.0, 30.0)];
    self.tfPhoneNum = _tfPhoneNum;
    self.tfPhoneNum.borderStyle = UITextBorderStyleRoundedRect;
    self.tfPhoneNum.delegate = self;
    self.tfPhoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.tfPhoneNum];
    [_tfPhoneNum release];
    
    //公司确认码输入框
//    UITextField *_tfCompanyNum = [[UITextField alloc] initWithFrame:CGRectMake(110.0, 100.0, 200.0, 30.0)];
//    self.tfCompanyNum = _tfCompanyNum;
//    self.tfCompanyNum.borderStyle = UITextBorderStyleRoundedRect;
//    self.tfCompanyNum.delegate = self;
//    self.tfCompanyNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    //self.tfPhoneNum.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:self.tfCompanyNum];
//    [_tfCompanyNum release];
    
    //个人确认码输入框
    UITextField *_tfPersonNum = [[UITextField alloc] initWithFrame:CGRectMake(110.0, 120.0, 200.0, 30.0)];
    self.tfPersonNum = _tfPersonNum;
    self.tfPersonNum.borderStyle = UITextBorderStyleRoundedRect;
    self.tfPersonNum.delegate = self;
    self.tfPersonNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //self.tfPhoneNum.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tfPersonNum];
    [_tfPersonNum release];
    
    //个人确认码8ee1c03a 公司确认550b04d4 
    
    //13012345673	d0a87429
    self.tfPhoneNum.text = @"18801167317";//13012345675
    //self.tfCompanyNum.text = @"550b04d4"; //不变
    self.tfPersonNum.text = @"8ee1c03a";//84b43398 19070981
    
	//判断配置文件是否已经下载
    NSString *fileName = @"config.xml";
    BOOL fileIsExist = [LLFileManage fileIsExist:fileName];
    if (fileIsExist) {
        NSLog(@"已经下载到本地");
        NSData *data = [LLFileManage ReadFromFile:fileName];
        NSLog(@"data1==%@", data);
        [self getHostStr:data];
    }else{
        NSString *localFile = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
        NSData *data = [NSData dataWithContentsOfFile:localFile];
        //NSLog(@"data2==%@", data);
        [self getHostStr:data];
    }
}

//获得激活http地址
- (void)getHostStr:(NSData *)data
{
    if (data == nil) {
        return;
    }
    TBXML *tbxml = [TBXML tbxmlWithXMLData:data error:nil];
    
    TBXMLElement * root = tbxml.rootXMLElement;
	
	if (root) {
		TBXMLElement *location = [TBXML childElementNamed:@"location" parentElement:root];
        if (location) {
            TBXMLElement *confirmUrl = [TBXML childElementNamed:@"send-url" parentElement:location];
            if (confirmUrl) {
                NSString *str = [TBXML textForElement:confirmUrl];
                self.strHost = str;
                NSLog(@"=== strHost = %@", self.strHost);
            }

        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//收回虚拟键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.tfPhoneNum resignFirstResponder];
	//[self.tfCompanyNum resignFirstResponder];
	[self.tfPersonNum resignFirstResponder];    
	return YES;
}

//返回
- (void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务程序" 
    //                                                    message:@"恭喜,您已通过公司认证!" 
    //                                                   delegate:self 
    //                                          cancelButtonTitle:@"确定" 
    //                                          otherButtonTitles:nil, nil];
    //    
    //    [alert show];
    //    [alert release];
    //激活成功
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ACTIVATION_LOCALSTR];
 
}

//确认

/**
 * 用户信息提交按HTTP协议，通过post方法提交以指定的服务地址中，提交的信息字段定义如下：
 * @param  no   手机号码    需要加密
 * @param  rx   公司确认码(短信通知，10个字符） 不加密
 * @param  ry   个人确认码(短信通知，10个字符） 不加密
 * @param  rt   手机时间  (安全校验用)  不需加密      
 * @param  idc  校验码
 * @post   http://konka.mymyty.com/GPSBack.do?no=18238186018&rx=aaa&ry=bbb&rt=2012-02-13 12:00:30.098&idc=3xxaaddd
 *         time+.+三个随机数 idc = 一个随机数+crc
 */

- (void)actionConfirm
{
    NSLog(@"激活,确认按钮");
    
    //文本输入框判断
    NSString *alertStr = @"";
    if ([self.tfPhoneNum.text isEqualToString:@""] || self.tfPhoneNum.text == nil ||
        [self.tfPersonNum.text isEqualToString:@""] || self.tfPersonNum.text == nil) {
        
        
        if ([self.tfPhoneNum.text isEqualToString:@""] || self.tfPhoneNum.text == nil) {
            alertStr = @"手机号码不能为空！";
        }else if ([self.tfPersonNum.text isEqualToString:@""] || self.tfPersonNum.text == nil) {
            alertStr = @"个人确认码不能为空！";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" 
                                                        message:alertStr 
                                                       delegate:self 
                                              cancelButtonTitle:@"确定" 
                                              otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        return;
    }
    
    NSString *no = self.tfPhoneNum.text;   //手机号码
    NSString *rx = COMPANY_NUM;//self.tfCompanyNum.text; //公司确认码 （短信通知，10个字符）
    NSString *ry = self.tfPersonNum.text;  //个人确认码  (短信通知，10个字符）
    NSString *rt = [UtilityClass getSystemTime:@"yyyy-MM-dd HH:mm:ss"];     //手机时间 （安全校验用）
    
    NSLog(@"加密前：no = %@", no);
    NSLog(@"加密前：rx = %@", rx);
    NSLog(@"加密前：rr = %@", ry);
    NSLog(@"手机发送时间：rt = %@", rt);
    NSLog(@"------------------------");
    
    //手机号 数据加密
    NSString *_no = [PBEWithMD5AndDES encrypt:no password:nil];
    NSString *_rx = [PBEWithMD5AndDES encrypt:rx password:nil];
    NSString *_ry = [PBEWithMD5AndDES encrypt:ry password:nil];
    NSLog(@"加密后：_no = %@", _no);
    NSLog(@"加密后：_rx = %@", _rx);
    NSLog(@"加密后：_ry = %@", _ry);
    NSLog(@"------------------------");
    
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
    

    NSString *crc = [UtilityClass getVertifyCode:_no encryptLongitude:_rx encryptLatitude:_ry systemTime:rt tranArray:transArr];
    NSLog(@"随机序列生成校验码crc = %@", crc);
    

    // 手机发送的数据相当于以下
    NSString *postStr = [NSString stringWithFormat:@"no=%@&rx=%@&ry=%@&rt=%@.%d%d%d&idc=%d%@", _no, rx, ry, rt, arr[0], arr[1], arr[2], arr[3], crc];
    NSLog(@"手机发送信息：%@", postStr);


    NSString *_rt = [NSString stringWithFormat:@"%@.%d%d%d", rt, arr[0], arr[1], arr[2]];
    NSLog(@"_rt = %@", _rt);
    NSString *_idc= [NSString stringWithFormat:@"%d%@", arr[3], crc];
    NSLog(@"_idc = %@", _idc);
    
    NSURL *url = [NSURL URLWithString:@"http://konka.mymyty.com/GPSBack.do"];
    NSLog(@"url = %@", url);
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] initWithCapacity:5];
    [postData setValue:_no forKey:@"no"];
    [postData setValue:_rx forKey:@"rx"];
    [postData setValue:_ry forKey:@"ry"];
    [postData setValue:_rt forKey:@"rt"];
    [postData setValue:_idc forKey:@"idc"];
    NSLog(@"===postData = %@", postData);

    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setRequestMethod:@"POST"];
    request.delegate = self;

//    NSString *jsonString = [postData JSONRepresentation];
//    NSLog(@"Send data:%@",jsonString);
//    NSData *jsonData = [UtilityClass UTF8StringToData:jsonString];
//    NSLog(@"jsonData = %@", jsonData);
    
    [request setPostValue:postData forKey:@"http://konka.mymyty.com/GPSBack.do"];
    [request setTimeOutSeconds:1200];
    [request startAsynchronous]; //异步执行
    [request release];
        
     
#ifdef LL_DEBUG
    //解密过程 测试加密算法
    NSString *t_z = [NSString stringWithFormat:@"%@.%d%d%d", rt, arr[0], arr[1], arr[2]];
    NSString *t_idc = [NSString stringWithFormat:@"%d%@", arr[3], crc];
    
    // 1.核对校验码
    if ([UtilityClass checkVerifyCode:_no encryptLongitude:_rx encryptLatitude:_ry systemTime:t_z idcStr:t_idc]) {
        // 2.解密数据
        NSLog(@"通过校验！");
        
        NSString *str1 = [PBEWithMD5AndDES decrypt:_no password:nil];
        NSString *str2 = [PBEWithMD5AndDES decrypt:_rx password:nil];
        NSString *str3 = [PBEWithMD5AndDES decrypt:_ry password:nil];
        NSLog(@"===str1 = %@", str1);
        NSLog(@"===str2 = %@", str2);
        NSLog(@"===str3 = %@", str3);

    } else {
        // 违法数据拒绝处理
        NSLog(@"没有通过校验！");
    }
#endif

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
    
    NSString *jsonString = [[request responseData] JSONRepresentation];
    NSLog(@"Json data:%@",jsonString);
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    //NSLog(@"responseHeaders = %@", responseHeaders);
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    //NSLog(@"data123 = %@", data);
    NSLog(@"456= %@", [UtilityClass DataToUTF8String:data]);
}



- (void)Getdata:(ASIHTTPRequest *)request
{	
	//[tooles removeHUD];	
	NSData *response = [request responseData];
    
    //[LLFileManage WritteToFile:response FileName:@"config.xml"];
	 NSLog(@"response = %@ ", response);
    
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[[NSString alloc] initWithData:response encoding:enc] autorelease];
    
     //NSString *retStr = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
	
	retStr = [retStr stringByReplacingOccurrencesOfString:@"\"GB2312\"" withString:@"\"UTF-8\""];
	
    NSLog(@"测试--------XML:%@",retStr);
    
	NSData *data = [retStr dataUsingEncoding:NSUTF8StringEncoding];	
    NSLog(@"data = %@ ", data);
	
}

//网络错误处理
- (void)GetErr:(ASIHTTPRequest *)request
{
    //	[tooles removeHUD];
    //	[tooles MsgBox:@"连接超时，等会试试"];
    NSLog(@"失败。。。。");
    
    
}

-(void)performRequest{
    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://konka.mymyty.com/GPSBack.do"]];
//    
//    NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonMessage length]];
//    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    //[request addValue: jsonAction forHTTPHeaderField:@"JSONAction"];
//    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody: [jsonMessage dataUsingEncoding:NSUTF8StringEncoding]];
//    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if( theConnection )
//    {
//        webData = [[NSMutableData data] retain];
//    }
//    else
//    {
//        NSLog(@"theConnection is NULL");
//    }
//    [pool release];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength: 0];
    //self.resultArray = [[NSMutableArray alloc] init];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"123===data = %@", data);
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"ERROR with theConenction");
    //NSDictionary *errorDic = [NSDictionary dictionaryWithObject:error forKey:@"error"];
    //[self.resultArray addObject:errorDic];
    [connection release];
    [webData setLength:0];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"DONE. Received Bytes: %d", [webData length]);
    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", theXML);
    [theXML release];
    if([webData length] > 0){
        
        NSLog(@"ok!!!!!!!!!!");
//        parser = [[NSXMLParser alloc] initWithData:webData];
//        [parser setDelegate:self];
//        [parser parse]; 
    }
}






							
@end
