//
//  CompanyInfoViewController.h
//  GpsService
//
//  Created by LiuLei Coolin on 12-3-5.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface CompanyInfoViewController : UIViewController<MBProgressHUDDelegate>
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSString *strUrl;

- (void)actionBack;
@end
