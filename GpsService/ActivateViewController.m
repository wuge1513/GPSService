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

#import "ASIFormDataRequest.h"
#import "TBXML.h"
#import "XMLHelper.h"



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
        self.title = NSLocalizedString(@"身份确认", nil);
    
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
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //手机号标签
    UILabel *_lblPhoneNum = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 60.0, 100.0, 30.0)];
    self.lblPhoneNum = _lblPhoneNum;
    self.lblPhoneNum.text = NSLocalizedString(@"确认手机号", nil);
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
    self.lblPersonNum.text = NSLocalizedString(@"个人确认码", nil);
    self.lblPersonNum.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.lblPersonNum];
    [_lblPersonNum release];
    
    //确认手机号输入框
    UITextField *_tfPhoneNum = [[UITextField alloc] initWithFrame:CGRectMake(110.0, 60.0, 200.0, 30.0)];
    self.tfPhoneNum = _tfPhoneNum;
    self.tfPhoneNum.borderStyle = UITextBorderStyleRoundedRect;
    self.tfPhoneNum.delegate = self;
    self.tfPhoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.tfPhoneNum.tag = 10001;
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
    self.tfPersonNum.tag = 10002;
    [self.view addSubview:self.tfPersonNum];
    [_tfPersonNum release];
    
    //个人确认码8ee1c03a 公司确认550b04d4 
    
    //13012345673	d0a87429
    //self.tfPhoneNum.text = @"18801167317";//13012345675
    //self.tfCompanyNum.text = @"550b04d4"; //不变
    //self.tfPersonNum.text = @"550c527f";//84b43398 19070981
    
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
		TBXMLElement *confirm = [TBXML childElementNamed:@"confirm" parentElement:root];
        if (confirm) {
            TBXMLElement *confirmUrl = [TBXML childElementNamed:@"confirm-url" parentElement:confirm];
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


//限制输入框字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 10001) {
        if (range.location >= 11)
            return NO; // return NO to not change text
        return YES;
    }
    
    if (textField.tag == 10002) {
        if (range.location >= 8)
            return NO; // return NO to not change text
        return YES;
    }
    return YES;
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

}

//确认

/**
 * 用户信息提交按HTTP协议，通过post方法提交以指定的服务地址中，提交的信息字段定义如下：
 * @param  no   手机号码    需要加密
 * @param  rx   公司确认码(短信通知，10个字符） 加密
 * @param  ry   个人确认码(短信通知，10个字符） 加密
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
            alertStr = NSLocalizedString(@"手机号码不能为空！", nil);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil) 
                                                            message:alertStr 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil) 
                                                  otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
            return;
        }else if ([self.tfPersonNum.text isEqualToString:@""] || self.tfPersonNum.text == nil) {
            //若为空则赋值1
            self.tfPersonNum.text = @"1";
        }
    }
    
    NSString *no = @"18801167317";//self.tfPhoneNum.text;   //手机号码
    NSString *rx = COMPANY_NUM;//self.tfCompanyNum.text; //公司确认码 （短信通知，10个字符）
    NSString *ry = @"550c527f";//self.tfPersonNum.text;  //个人确认码  (短信通知，10个字符）
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
//    NSString *postStr = [NSString stringWithFormat:@"no=%@&rx=%@&ry=%@&rt=%@.%d%d%d&idc=%d%@", _no, rx, ry, rt, arr[0], arr[1], arr[2], arr[3], crc];
//    NSLog(@"手机发送信息：%@", postStr);


    NSString *_rt = [NSString stringWithFormat:@"%@.%d%d%d", rt, arr[0], arr[1], arr[2]];
    NSLog(@"_rt = %@", _rt);
    NSString *_idc= [NSString stringWithFormat:@"%d%@", arr[3], crc];
    NSLog(@"_idc = %@", _idc);
    
    NSURL *url = [NSURL URLWithString:self.strHost];
    NSLog(@"url = %@", url);
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setRequestMethod:@"POST"];
    request.delegate = self;
    [request setAllowCompressedResponse:NO];

    [request setPostValue: _no forKey:@"no"];
    [request setPostValue:_rx forKey:@"rx"];
    [request setPostValue:_ry forKey:@"ry"];
    [request setPostValue:_rt forKey:@"rt"];
    [request setPostValue:_idc forKey:@"idc"];
    [request setTimeOutSeconds:1000];
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
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"===%@", request.responseStatusMessage);
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
    NSAssert(data, @"Activate request: receive data is nil.");
    
    
    NSLog(@"----xml = %@", [UtilityClass DataToUTF8String:data]);
    

    return;

    TBXML *tbxml = [TBXML tbxmlWithXMLData:data error:nil];
    
    TBXMLElement * root = tbxml.rootXMLElement;
	
	if (root) {
        
        NSString *strCode = @"";
        NSString *strMsg = @"";
		TBXMLElement *return_info = [TBXML childElementNamed:@"return-info" parentElement:root];
        if (return_info) {
            TBXMLElement *return_code = [TBXML childElementNamed:@"return-code" parentElement:return_info];
            if (return_code) {
                strCode = [TBXML textForElement:return_code];
                //NSLog(@"=== strCode = %@", strCode);
            }
            
            TBXMLElement *msg = [TBXML childElementNamed:@"msg" parentElement:return_info];
            if (msg) {
                strMsg = [TBXML textForElement:msg];
                //NSLog(@"=== strMsg = %@", strMsg);
            }
            
            //激活成功保存配置文件到本地
            if ([strCode isEqualToString:@"0"]) {
                
                //配置文件保存到本地沙盒
                //[LLFileManage WritteToFile:data FileName:@"config.xml"];
                
                //解析公司网址
                TBXMLElement *companyUrl = [TBXML childElementNamed:@"company-info" parentElement:root];
                if (companyUrl) {
                    TBXMLElement *pageUrl = [TBXML childElementNamed:@"page-url" parentElement:companyUrl];
                    if (pageUrl) {
                        NSString *strUrl = [TBXML textForElement:pageUrl];
                        //保存公司网址
                        [[NSUserDefaults standardUserDefaults] setObject:strUrl forKey:COMPANY_URL];
                    }
                }
                
                //获取配置文件信息
                TBXMLElement *config_update = [TBXML childElementNamed:@"config-update" parentElement:root];
                if (config_update) {
                    //配置文件版本号
                    //配置文件更新地址
                    //配置文件更新时间
                    TBXMLElement *time = [TBXML childElementNamed:@"time" parentElement:config_update];
                    if (time) {
                        NSString *strTime = [TBXML textForElement:time];
                        NSLog(@"strTime = %@", strTime);
                        
                        NSArray *arr = [[[NSArray alloc] init] autorelease]; 
                        arr = [strTime componentsSeparatedByString:@","];
                        NSLog(@"arr = %@", arr);
                        
                        //定时更新配置文件
                        for (NSInteger i = 0; i < [arr count]; i++) {
                             NSInteger timeInterval = [UtilityClass getTimeInterval:[arr objectAtIndex:i]];
                            [UtilityClass setAlarm:timeInterval Alert:@"更新配置文件"];
                        }
                    }
                    
                    /**
                     *  提交位置信息定时 测试
                     */
                    NSString *strSendTime2 = [XMLHelper getNodeStr:@"location" secondNode:@"send-time"];
                    NSLog(@"strSendTime2 = %@", strSendTime2);
                    
                    NSString *strSendDate2 = [XMLHelper getNodeStr:@"location" secondNode:@"send-date"];
                    NSLog(@"strSendDate2 = %@", strSendDate2);
                    
                    [UtilityClass postLocalNotification:strSendTime2 blStr:strSendDate2];
                }
            }
            
            //返回结果提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"定位服务程序", nil) 
                                                            message:strMsg 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil) 
                                                  otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
        }
    }
}

						
@end
