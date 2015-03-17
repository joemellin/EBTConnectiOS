//
//  Tool3ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "Tool3ViewController.h"
#import "SelectStateViewController.h"
@interface Tool3ViewController ()

@end

@implementation Tool3ViewController

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
    [super viewDidLoad];
    [self setNavTitle:@"Emotional Housecleaning"];
    [self addRightArrowButton];
    
    self.displayList = @[
                         @"I feel angry that...",
                         @"I feel sad that...",
                         @"I feel afraid that...",
                         @"I feel guilty that...",
                         @"I feel grateful that...",
                         @"I feel happy that...",
                         @"I feel proud that..."
                         ];
    
    // Do any additional setup after loading the view from its nib.
    float delta = kiPhone5HeightDelta/2;
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 145, 320, 34)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text =  displayList[self.currentIndex];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = UITextAlignmentCenter;
    [Utils applyiPhone4YDelta:-delta forView:label];
    [self.view addSubview:label];
}

-(void)next{
    if (self.currentIndex == displayList.count - 1) {
        SelectStateViewController* vc = [[SelectStateViewController alloc] initWithNibName:@"SelectStateViewController" bundle:nil];
        vc.isRestartMode = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        Tool3ViewController* vc = [[Tool3ViewController alloc] initWithNibName:@"Tool3ViewController" bundle:nil];
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
