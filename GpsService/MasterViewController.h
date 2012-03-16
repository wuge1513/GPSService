//
//  MasterViewController.h
//  GpsService
//
//  Created by LiuLei on 12-2-25.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivateViewController;
@class GpsInfoViewController;

@interface MasterViewController : UIViewController<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *itemTableView;
@property (strong, nonatomic) UILabel *lblServiceState;
@property (strong, nonatomic) UIButton *btnConfirmGps;
@property (strong, nonatomic) UIButton *btnGetInfo;
@property (strong, nonatomic) ActivateViewController *activateViewController;

- (void)actionActivate;

- (IBAction)up:(id)sender;
- (IBAction)down:(id)sender;
@end
