//
//  MasterViewController.m
//  GpsService
//
//  Created by LiuLei on 12-2-25.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import "MasterViewController.h"
#import "ActivateViewController.h"
#import "GpsInfoViewController.h"

#import "CompanyInfoViewController.h"
#import "Config.h"
#import "LLFileManage.h"
#import "XMLHelper.h"


NSInteger count = 2;
@implementation MasterViewController

@synthesize activateViewController = _activateViewController;
@synthesize lblServiceState;
@synthesize btnConfirmGps, btnGetInfo;
@synthesize itemTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = NSLocalizedString(@"定位服务程序", nil);
        
        //自定义按钮
//        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [selectButton setFrame:CGRectMake(0.f, 260.f, 60.0, 30.0)];
//        [selectButton setTitle:@"激活" forState:UIControlStateNormal];
//        [selectButton addTarget:self action:@selector(actionGetInfo:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *selectButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:selectButton] autorelease];

        //默认激活按钮
        UIBarButtonItem *selectButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"激活", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(actionActivate)];
        self.navigationItem.rightBarButtonItem = selectButtonItem;
        [selectButtonItem release];
    }
    return self;
}
							
- (void)dealloc
{
    [btnGetInfo release];
    [btnGetInfo release];
    [lblServiceState release];
    [itemTableView release];
    [_activateViewController release];
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
    
    //背景颜色
    self.view.backgroundColor = [UIColor grayColor];
    
    //激活状态提示标签
    UILabel *_lblServiceState = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 20.0, 240.0, 40.0)];
    self.lblServiceState = _lblServiceState;
    self.lblServiceState.text = NSLocalizedString(@"您的帐号尚未激活", nil);
    self.lblServiceState.backgroundColor = [UIColor clearColor];
    //self.lblServiceState.textColor = [UIColor blueColor];
    self.lblServiceState.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:self.lblServiceState];
    [_lblServiceState release];
    

    UITableView *_itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 80.0, 320.0, 300.0) style:UITableViewStyleGrouped];
    self.itemTableView = _itemTableView;
    [_itemTableView release];
    self.itemTableView.backgroundColor = [UIColor clearColor];
    self.itemTableView.delegate = self;
    self.itemTableView.dataSource = self;
    [self.view addSubview:self.itemTableView];
    
	
}

//激活按钮事件
- (void)actionActivate{
    NSLog(@"123");
    
    if (!self.activateViewController) {
        self.activateViewController = [[[ActivateViewController alloc] initWithNibName:@"ActivateViewController" bundle:nil] autorelease];
    }
    [self.navigationController pushViewController:self.activateViewController animated:YES];
}

#pragma mark-
#pragma mark-激活提示框
//alert 提示
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10001) {
        if (buttonIndex == 0) {//选择激活
            if (!self.activateViewController) {
                self.activateViewController = [[[ActivateViewController alloc] initWithNibName:@"ActivateViewController" bundle:nil] autorelease];
            }
            [self.navigationController pushViewController:self.activateViewController animated:YES];
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
    
    if ([self isActivation]) {
        self.lblServiceState.text = NSLocalizedString(@"您的帐号已经激活", nil);

    }
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.textAlignment = UITextAlignmentCenter;
    // Configure the cell.
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"获取GPS信息", nil);
    }else if(indexPath.row == 1){
        cell.textLabel.text = NSLocalizedString(@"获取公司信息", nil);
    }
    
    return cell;
}

//判断号码是否激活
- (BOOL)isActivation
{
    return [LLFileManage fileIsExist:@"config.xml"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isActivati = [self isActivation];
    
    if (!isActivati) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) 
                                                        message:NSLocalizedString(@"请先激活", nil) 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"激活", nil) 
                                              otherButtonTitles:NSLocalizedString(@"取消", nil), nil];
        
        alert.tag = 10001;
        [alert show];
        [alert release];
    }else{
        switch (indexPath.row) 
        {
            case 0:
            {
                GpsInfoViewController *gpsInfoViewController = [[GpsInfoViewController alloc] initWithNibName:@"GpsInfoViewController" bundle:nil];
                [self.navigationController pushViewController:gpsInfoViewController animated:YES];
                [gpsInfoViewController release];
            
                break;
            }
            case 1:
            {
                CompanyInfoViewController *comInfoCtl = [[CompanyInfoViewController alloc] init];
                comInfoCtl.strUrl = [XMLHelper getNodeStr:@"location" secondNode:@"send-url"];//@"konka.mymyty.com";
                [self.navigationController pushViewController:comInfoCtl animated:YES];
                [comInfoCtl release];
                break;
            }
            default:
                break;
        }
    }
}


@end
