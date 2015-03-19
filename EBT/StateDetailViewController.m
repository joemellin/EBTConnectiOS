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
    titles = @[@"Joy Point!",@"Feelings Check",@"Emotional Housecleaning",@"Cycle Tool",@"Damage Control"];
    results = @[@"You are going great!",@"You are doing fine.",@"You are a little stressed.",@"Your brain is in stress",@"You are in a full\nblown stress response."];
    details = @[@"",@"Following the following\npromps to connect with yourself\nand get to one!",@"Following the following\npromps and finish the sentences\nwith whatever feels right.",
                @"This is a great oppurtunity\nto process your emotions and\nrewire your brain.",
                @"Say the following words over\nand over to yourself until\nyou feel the stress fade."];

    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupUI{
    [self setNavTitle:titles[self.state]];
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 100, 320, 44)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text =  results[self.state];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    NSString* text = details[self.state];
    UIFont* font = [UIFont systemFontOfSize:17];
    float h = [Utils calculateHeightOfMultipleLineText:text withFont:font withWidth:300];
    label = [[UILabel alloc] initWithFrame:CGRectMake(10 , 150, 300, h)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text =  text;
    label.backgroundColor= [UIColor clearColor];
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    float yDelta = -80;
    if (self.state != 0) {
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, 430, 0, 0);
        [button setTitle:@"ACCEPT STATE" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];

        [button setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"greyaccept"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(acceptState) forControlEvents:UIControlEventTouchUpInside];
        [self setViewFrame:button];
        [Utils applyiPhone4YDelta:yDelta forView:button];
        [self.view addSubview:button];
        
       button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"USE TOOL" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];

        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(180, 430, 0, 0);
        [button setBackgroundImage:[UIImage imageNamed:@"blueaccept2"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(useTool) forControlEvents:UIControlEventTouchUpInside];
        [self setViewFrame:button];
        [Utils applyiPhone4YDelta:yDelta forView:button];
        [self.view addSubview:button];

    }
    else{
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(160-106/2, 430, 0, 0);
        [button setTitle:@"ACCEPT STATE" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"blueaccept"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(acceptState) forControlEvents:UIControlEventTouchUpInside];
        [self setViewFrame:button];
        [Utils applyiPhone4YDelta:yDelta forView:button];
        [self.view addSubview:button];
    }
    

    
}

-(void)acceptState{
    AcceptStateViewController* vc = [[AcceptStateViewController alloc] initWithNibName:@"AcceptStateViewController" bundle:nil];
    vc.isJoyMode = self.state == 0;
    vc.state = self.state;
    [self.navigationController pushViewController:vc animated:YES];

    
}

-(void)useTool{
    if (_state == 1) {
        [Utils showSubViewWithName:@"Tool2S2ViewController" withDelegate:self];
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
