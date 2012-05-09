//
//  CompanyInfoViewController.m
//  GpsService
//
//  Created by LiuLei Coolin on 12-3-5.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import "CompanyInfoViewController.h"

@implementation CompanyInfoViewController
@synthesize strUrl;
@synthesize HUD;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"公司信息", nil);
        
        //默认返回按钮
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(actionBack)];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        [leftButtonItem release];
        
    }
    return self;
}

//返回方法
- (void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [HUD release];
    [strUrl release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)myTask {
	// Do something usefull in here instead of sleeping ...
	sleep(2);
    [self.HUD removeFromSuperview];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *_strUrl = self.strUrl;
    NSURL *_url = [NSURL URLWithString:_strUrl];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.HUD];
	self.HUD.delegate = self;
	self.HUD.labelText = @"正在加载...";
    //[self.HUD show:YES];
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    //UIWebView
	UIWebView *theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0 - 44)];
    [self.view addSubview:theWebView];
    [theWebView release];
    
    NSURLRequest *_request = [[[NSURLRequest alloc] initWithURL:_url] autorelease];
    [theWebView loadRequest:_request];
    
	theWebView.backgroundColor = [UIColor clearColor];
	theWebView.opaque = NO;
	theWebView.dataDetectorTypes=UIDataDetectorTypeNone;
	theWebView.clearsContextBeforeDrawing = NO;
	theWebView.dataDetectorTypes=UIDataDetectorTypeNone;
	theWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    theWebView.scalesPageToFit = YES;
    
	
    //去除拖拽效果线条 remove shadow view when drag web view
    for (UIView *subView in [theWebView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
