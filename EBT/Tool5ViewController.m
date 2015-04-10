//
//  Tool5ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "Tool5ViewController.h"
#import "SelectStateViewController.h"
@interface Tool5ViewController ()

@end

@implementation Tool5ViewController

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
    [self setNavTitle:@"Damage Control"];
    
    self.titles = @[
                         @"Do Not Judge",
                         @"Minimize Harm",
                         @"Know it Will Pass"
                         ];
    
    // Do any additional setup after loading the view from its nib.
    float delta = kiPhone5HeightDelta/2;
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 142, kScreenBounds.size.width, 150)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text =  self.titles[self.currentIndex];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    [Utils applyiPhone4YDelta:-delta forView:label];
    [self.view addSubview:label];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
