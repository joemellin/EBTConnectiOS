//
//  Tool3ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "BaseToolViewController.h"
#import "SelectStateViewController.h"
@interface BaseToolViewController ()

@end

@implementation BaseToolViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Customization
    }
    return self;
}

- (void)viewDidLoad
{
    needsNavBar = YES;
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    
    float yDelta = -50;
    if (self.currentIndex == self.titles.count - 1) {
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, kScreenBounds.size.height - 150, 0, 0);
        [button setTitle:@"SAY IT AGAIN" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        
        [button setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"greycontinue"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
        [self setViewFrame:button];
        [Utils applyiPhone4YDelta:yDelta forView:button];
        [self.view addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"CONTINUE" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(180, kScreenBounds.size.height - 150, 0, 0);
        [button setBackgroundImage:[UIImage imageNamed:@"bluecontinue"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [self setViewFrame:button];
        [Utils applyiPhone4YDelta:yDelta forView:button];
        [self.view addSubview:button];
        
    }
    else{
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenBounds.size.width/2-106/2, kScreenBounds.size.height - 150, 0, 0);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bluecontinue"] forState:UIControlStateNormal];
        [button setTitle:@"CONTINUE" forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [self setViewFrame:button];
        [Utils applyiPhone4YDelta:yDelta forView:button];
        [self.view addSubview:button];
    }
}

-(void)restart{
    int index = [[self.navigationController viewControllers] count] - self.titles.count;
    [self.navigationController popToViewController:[self.navigationController viewControllers][index] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
