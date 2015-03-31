//
//  Tool3ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "Tool2ViewController.h"
#import "SelectStateViewController.h"
@interface Tool2ViewController ()
@end

@implementation Tool2ViewController

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
    [self setNavTitle:@"Brain State 2"];
    
    self.titles = @[@"How do I feel?", @"What do I need?", @"Do I need support?"];
    self.details = @[@"Take a deep breakth and ask, \"How do I feel?\"\nPause and become aware of your strongest feelings.\n\n\nThe Basic Feelings\n\nAngry, Sad, Afraid, Guilty, Tired, Tense, Hungry, Full, Lonely and Sick\n\nGrateful, Happy, Secure, Proud, Rested, Relaxed, Satisfied, Loved, Loving and Healthy.",
                 @"Given how you feel, what do you really need?\n\nThe Basic Needs\nTo connect with myself(e.g., feel my feelings)\nTo connect with others (e.g., make a community connection)\nTo meet the logical need (e.g., I am tired. I need sleep.)",
                 @"What support do you need from others?\n\nThe Basic Support Needs\n\nTo listen to my feelings and needs\nTo share their feelings and needs\nTo help me in another way"];
    
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(10 , 10, kScreenBounds.size.width-20, 44)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text =  self.titles[self.currentIndex];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    NSString* text = self.details[self.currentIndex];
    UIFont* font = [UIFont systemFontOfSize:17];
    float h = [Utils heightWithText:text andFont:font andMaxWidth:kScreenBounds.size.width-20];
    label = [[UILabel alloc] initWithFrame:CGRectMake(10 , 50, kScreenBounds.size.width-20, h)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text =  text;
    label.backgroundColor= [UIColor clearColor];
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    [super viewDidLoad];
}

-(void)next{
    if (self.currentIndex == self.titles.count - 1) {
        SelectStateViewController* vc = [[SelectStateViewController alloc] init];
        vc.isRestartMode = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        Tool2ViewController* vc = [[Tool2ViewController alloc] init];
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
