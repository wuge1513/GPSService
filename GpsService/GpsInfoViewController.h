//
//  GpsInfoViewController.h
//  GpsService
//
//  Created by LiuLei on 12-2-25.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GpsInfoViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *latitudeTextField;  
@property (strong, nonatomic) IBOutlet UITextField *longitudeTextField;  
@property (strong, nonatomic) IBOutlet UITextField *accuracyTextField;
@property (strong, nonatomic) IBOutlet UITextField *tfLocationWay; 
@property (strong, nonatomic) IBOutlet UITextField *tfLocationTime; 
@property (strong, nonatomic) IBOutlet UITextField *tfPhoneNum; 

@property (strong, nonatomic) CLLocationManager *lm;  

//返回
- (void)actionBack;
- (void)getLocationInfo;
- (void)actionConfirm;

//- (void)Getdata:(ASIHTTPRequest *)request;
//- (void)GetErr:(ASIHTTPRequest *)request;
@end
