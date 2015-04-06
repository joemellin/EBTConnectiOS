//
//  StateDetailViewController.m
//  EBT
//
//  Created by ross chen on 8/13/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "StateDetailViewController.h"
#import "AcceptStateViewController.h"
@interface StateDetailViewController ()

@end

@implementation StateDetailViewController

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
    titles = @[@"Joy Point!",@"Feelings Check",@"Emotional Housecleaning",@"Cycle Tool",@"Damage Control"];
//    results = @[@"You are in Brain State 1.",
//                @"You are in Brain State 2.",
//                @"You are in Brain State 3.",
//                @"You are in Brain State 4",
//                @"You are in Brain State 5"];
    details = @[@"Your brain is very connected. You are present, aware and feel great.\nAccept your state or, better yet, strengthen that connection and move up your set point by using this tool.",
                @"Your brain is connected and you feel good.\nAccept your state. Better yet, use this tool to spiral up.\nSpiraling up helps you move up your set point.",
                @"You feel a little stressed. Use this tool to spiral up, feel better and move up your set point.",
                @"This is a moment of opportunity.\nBy uing the cycle tool now, you can connect, rewire and spiral up!",
                @"You feel stressed out! Let's quiet that disconnect wire!\nTake a deep breath and say these words over and over until you feel better. This will pass!"];

    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupUI{
    [self setNavTitle:titles[self.state]];
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 100, kScreenBounds.size.width, 44)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text = [NSString stringWithFormat:@"You are in Brain State %i", self.state+1];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    NSString* text = details[self.state];
    UIFont* font = [UIFont systemFontOfSize:17];
    float h = [Utils heightWithText:text andFont:font andMaxWidth:kScreenBounds.size.width-20];
    label = [[UILabel alloc] initWithFrame:CGRectMake(10 , 150, kScreenBounds.size.width-20, h)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text =  text;
    label.backgroundColor= [UIColor clearColor];
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    float yDelta = -80;
//    if (self.state != 0) {
    
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"ACCEPT STATE" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];

        [button setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"greyaccept"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(acceptState) forControlEvents:UIControlEventTouchUpInside];
        [self setViewFrame:button];
        [Utils applyiPhone4YDelta:yDelta forView:button];
        button.frame = CGRectMake(50, kScreenBounds.size.height - 150, button.frame.size.width, button.frame.size.height);
        [self.view addSubview:button];
        
       button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"USE TOOL" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];

        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"blueaccept2"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(useTool) forControlEvents:UIControlEventTouchUpInside];
        [self setViewFrame:button];
        [Utils applyiPhone4YDelta:yDelta forView:button];
        button.frame = CGRectMake(kScreenBounds.size.width-button.frame.size.width-50, kScreenBounds.size.height - 150, button.frame.size.width, button.frame.size.height);
        [self.view addSubview:button];
}

-(void)acceptState{
    AcceptStateViewController* vc = [[AcceptStateViewController alloc] init];
    vc.isJoyMode = self.state == 0;
    vc.state = self.state;
    [self.navigationController pushViewController:vc animated:YES];

    
}

-(void)useTool{
    if (_state == 0) {
        [Utils showSubViewWithName:@"Tool1ViewController" withDelegate:self];
    }
    else if (_state == 1) {
        [Utils showSubViewWithName:@"Tool2ViewController" withDelegate:self];
    }
    else if (_state == 2) {
        [Utils showSubViewWithName:@"Tool3ViewController" withDelegate:self];
    }
    else if (_state == 3) {
        [Utils showSubViewWithName:@"Tool4ViewController" withDelegate:self];
    }
    else if (_state == 4) {
        [Utils showSubViewWithName:@"Tool5ViewController" withDelegate:self];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
