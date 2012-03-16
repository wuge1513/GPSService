//
//  DetailViewController.h
//  GpsService
//
//  Created by LiuLei on 12-2-25.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ActivateViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSString *strHost;
@property (strong, nonatomic) UILabel *lblPhoneNum;
@property (strong, nonatomic) UILabel *lblCompanyNum;
@property (strong, nonatomic) UILabel *lblPersonNum;

@property (strong, nonatomic) UITextField *tfPhoneNum;
@property (strong, nonatomic) UITextField *tfCompanyNum;
@property (strong, nonatomic) UITextField *tfPersonNum;

- (void)getHostStr:(NSData *)data;
- (void)actionBack;
- (void)actionConfirm;




@end
