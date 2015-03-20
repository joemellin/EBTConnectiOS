//
//  Tool5ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "Tool1ViewController.h"
#import "SelectStateViewController.h"
@interface Tool1ViewController ()

@end

@implementation Tool1ViewController

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
    needsNavBar = YES;
    [self setNavTitle:@"Sanctuary"];
    
    self.titles = @[
                         @"Take a deep breath...",
                         @"Shoulders back... Assume Body at 1.",
                         @"Lovingly observe yourself.",
                         @"Connect with your sanctuary, the safe place within.",
                         @"Feel a wave of compassion for yourself.",
                         @"Feel a wave of compassion for others.",
                         @"Feel a wave of compassion for all living beings.",
                         @"Feel a surge of joy!",
                         ];
    
    // Do any additional setup after loading the view from its nib.
    float delta = kiPhone5HeightDelta/2;
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 142, 320, 150)];
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

-(void)next{
    if (self.currentIndex == self.titles.count - 1) {
        SelectStateViewController* vc = [[SelectStateViewController alloc] initWithNibName:@"SelectStateViewController" bundle:nil];
        vc.isRestartMode = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        Tool1ViewController* vc = [[Tool1ViewController alloc] initWithNibName:@"Tool1ViewController" bundle:nil];
        vc.currentIndex = self.currentIndex + 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
