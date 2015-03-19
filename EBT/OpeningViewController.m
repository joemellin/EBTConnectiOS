//
//  OpeningViewController.m
//  EBT
//
//  Created by ross chen on 8/6/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "OpeningViewController.h"

@interface OpeningViewController ()

@end

@implementation OpeningViewController

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
    // Do any additional setup after loading the view from its nib.
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-143)/2, 135, 0, 0)];
    imageView.image = [UIImage imageNamed:@"logo.png"];
    [self setViewFrame:imageView];
    [self.view addSubview:imageView];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((320-205)/2, 400, 0, 0);
	[button setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(newToEBT) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
    [button setTitle:@"NEW TO EBT" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((320-205)/2, 447, 0, 0);
	[button setBackgroundImage:[UIImage imageNamed:@"graybutton.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
    [button setTitle:@"LOG IN" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [self applyIphone4YDeltaForSubviewsOfView:self.view];
    



}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utils setting:kLoginInfoDict] && ![Utils setting:kLoginBackTapped]) {
        [Utils showSubViewWithNameNoAnimation:@"LoginViewController" withDelegate:self];
    }

}

-(void)login{
    [Utils showSubViewWithName:@"LoginViewController" withDelegate:self];
}

-(void)newToEBT{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kWebsiteURL]];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
