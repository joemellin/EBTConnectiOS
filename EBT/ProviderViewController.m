//
//  ProviderViewController.m
//  EBT
//
//  Created by ross chen on 8/15/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "ProviderViewController.h"
#import "MessageViewController.h"
#import <UIImageView+AFNetworking.h>
@interface ProviderViewController ()

@end

@implementation ProviderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestUserInfo];

    // Do any additional setup after loading the view from its nib.
}

-(void)serverErrorHandler{
    [self addGroupBackButton];
}

-(void)connectionErrorHandler{
    [self addGroupBackButton];

}

-(void)setupUI{
    [self addGroupBackButton];
    //[self addLogoutButtonToView:self.view];


    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenBounds.size.width, kScreenBounds.size.height-20)];
    [self.view insertSubview:contentView atIndex:0];

    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    imageView.image = [UIImage imageNamed:@"providerface"];
    [self setViewFrame:imageView];
    imageView.tag = 0 + kBaseTag;
    
    [contentView addSubview:imageView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(104, 18, 113, 113)];
    imageView.tag = 100;
    [imageView setImageWithURL:[NSURL URLWithString:self.currentItem[kImageURL]]];
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.clipsToBounds = YES;
    
    [contentView addSubview:imageView];
    
    UIView* whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 142, kScreenBounds.size.width, 265-142)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 155, kScreenBounds.size.width, 30)];
    label.numberOfLines = 1;
    label.textColor = kDarkGrayTextColor;
    label.text =  self.currentItem[kName];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 185, kScreenBounds.size.width, 30)];
    label.numberOfLines = 1;
    label.textColor = kDarkGrayTextColor;
    label.text =  @"Certified EBT Provider";
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    
    float lastY = 225;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lastY, 0, 0)];
    imageView.image = [UIImage imageNamed:@"profileline"];
    [self setViewFrame:imageView];
    [contentView addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, lastY, 175, 40);
    UIImage *image = [UIImage imageNamed:@"messageicon"];
    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setTitle:@"Message" forState:UIControlStateNormal];
    [button setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(showMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
       
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lastY+40, 0, 0)];
    imageView.image = [UIImage imageNamed:@"profileline"];
    [self setViewFrame:imageView];

    [contentView addSubview:imageView];
    
    lastY = 300;
   
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , lastY, kScreenBounds.size.width, 30)];
    label.numberOfLines = 1;
    label.textColor = kDarkGrayTextColor;
    label.text =  [@"Purchased coaching" uppercaseString];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , lastY+30, kScreenBounds.size.width, 45)];
    label.numberOfLines = 1;
    label.textColor = kBlueTextColor;
    label.text =  [NSString stringWithFormat:@"%@",self.currentItem[@"num_coachings"]];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:50];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , lastY+75, kScreenBounds.size.width, 30)];
    label.numberOfLines = 1;
    label.textColor = kDarkGrayTextColor;
    label.text =  [@"25 min sessions" uppercaseString];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];





    
}

-(IBAction)requestUserInfo{
    NSDictionary* dict = [Utils setting:kUserInfoDict];
	NSString* urlStr = [NSString stringWithFormat:@"%@users/%@",kBaseURL, self.currentItem[kID] ];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    
	
	MyURLConnection* myconn = [[MyURLConnection alloc] initWithURL:urlStr target:self
												 succeededCallback:@selector(requestSucceeded:myURLConnection:)
													failedCallback:@selector(requestFailed:myURLConnection:)
														   context:[NSNumber numberWithInt:1]];
    [myconn get];
    [self showLoadingView];
	
}



-(void)requestSucceededResultHandler:(id)context result:(NSString*)result{
    NSLog(@"result:%@",result);
    
    
    
	if ([context intValue] == 1) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if (dict) {
            self.currentItem = dict;
            [self setupUI];
        }
        
	}
    
    
}

-(void)showMessage{
    MessageViewController *vc = [MessageViewController new];
    vc.imageCacheDict = self.imageCacheDict;
    vc.currentItem = [self.currentItem mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
