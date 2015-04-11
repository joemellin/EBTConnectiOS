//
//  Tool3ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "BaseToolViewController.h"
#import "SelectStateViewController.h"
#import "AcceptStateViewController.h"

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
    
    if (self.currentIndex == self.titles.count - 1) {
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Say it Again" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [button setTitleColor:kLightBlueColor forState:UIControlStateNormal];
        [button setBackgroundColor:kOffWhite];
        button.layer.cornerRadius = 10;
        button.layer.borderColor = [kLightBlueColor CGColor];
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(20, kScreenBounds.size.height - 138, (kScreenBounds.size.width-60)/2, 54);
        [self.view addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"whitehouse"] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [button setBackgroundColor:kLightBlueColor];
        button.layer.cornerRadius = 10;
        [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(40 + (kScreenBounds.size.width-60)/2, kScreenBounds.size.height - 138, (kScreenBounds.size.width-60)/2, 54);
        [self.view addSubview:button];
        
    }
    else{
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, kScreenBounds.size.height-138, kScreenBounds.size.width-40, 54);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:kLightBlueColor];
        button.layer.cornerRadius = 10;
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [button setTitle:@"Continue" forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)restart{
    int index = [[self.navigationController viewControllers] count] - self.titles.count;
    [self.navigationController popToViewController:[self.navigationController viewControllers][index] animated:YES];
}

-(void)next {
    if (self.currentIndex == self.titles.count - 1) {
        AcceptStateViewController* vc = [[AcceptStateViewController alloc] init];
        int state = [[Utils setting:@"currentStateSetting"] intValue];
        vc.state = state;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        id vc = [[[self class] alloc] init];
        [vc setCurrentIndex:self.currentIndex + 1];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
