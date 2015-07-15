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
    [self setNavTitle:@"Flow Tool"];
    
    self.titles = @[
                 @"I feel angry that...",
                 @"I feel sad that...",
                 @"I feel afraid that...",
                 @"I feel guilty that...",
                 @"I feel grateful that...",
                 @"I feel happy that...",
                 @"I feel secure that...",
                 @"I feel proud that..."
                 ];
    
    self.details = @[
                 @"Check in and take a deep breath.\nFeel angert, then express it!",
                 @"Feel sadness, then express it.",
                 @"Feel fear, then express it",
                 @"Feel guilt, then express it.\nIn the best of all worlds, I wish that I had not...",
                 @"Check for a slight positive charge in your body.\nThen feel your gratitude and express it.",
                 @"Feel happy, then express it.",
                 @"Feel secure - even a little bit secure, then express it.",
                 @"Express it. Notice a surge of release and joy."];
    
//    UILabel* label;
//    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 100, kScreenBounds.size.width, 44)];
//    label.numberOfLines = 0;
//    label.textColor = kDarkGrayTextColor;
//    label.text =  self.titles[self.currentIndex];
//    label.backgroundColor= [UIColor clearColor];
//    label.font = [UIFont boldSystemFontOfSize:16];
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label];
//    
//    NSString* text = self.details[self.currentIndex];
//    UIFont* font = [UIFont systemFontOfSize:17];
//    float h = [Utils heightWithText:text andFont:font andMaxWidth:kScreenBounds.size.width-20];
//    label = [[UILabel alloc] initWithFrame:CGRectMake(10 , 150, kScreenBounds.size.width-20, h)];
//    label.numberOfLines = 0;
//    label.textColor = kDarkGrayTextColor;
//    label.text =  text;
//    label.backgroundColor= [UIColor clearColor];
//    label.font = font;
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label];
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 142, kScreenBounds.size.width, 150)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text =  self.titles[self.currentIndex];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
