//
//  CallingViewController.m
//  EBT
//
//  Created by Adi on 3/26/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "CallingViewController.h"

@interface CallingViewController ()
@end

@implementation CallingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    needsNavBar = NO;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupUI {
    UILabel *nameLabel = [[UILabel alloc] init];
    UILabel *instructions = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    nameLabel.textColor = kLightBlueColor;
    instructions.textColor = kLightBlueColor;
    
    nameLabel.numberOfLines = 0;
    instructions.numberOfLines = 0;
    
    if(_isGroupCall) {
        nameLabel.text = [NSString stringWithFormat:@"Calling Your Group"];
        instructions.text = @"1) Your phone will ring\n\n2) When you answer you will join the group conference line.";
    } else {
        nameLabel.text = [NSString stringWithFormat:@"Calling %@", self.name];
        instructions.text = @"1) Your Phone will ring\n\n2) When you answer you will be connected to your group member";
    }
    
    nameLabel.font = [UIFont boldSystemFontOfSize:40];
    instructions.font = [UIFont boldSystemFontOfSize:20];
    
    float heightName = [Utils heightWithText:nameLabel.text andFont:nameLabel.font andMaxWidth:kScreenBounds.size.width-20];
    float heightInstructions = [Utils heightWithText:instructions.text andFont:instructions.font andMaxWidth:kScreenBounds.size.width-40];

    nameLabel.frame = CGRectMake(10, 40, kScreenBounds.size.width-20, heightName);
    instructions.frame = CGRectMake(10, 80 + heightName, kScreenBounds.size.width-40, heightInstructions);
    
    [self.view addSubview:nameLabel];
    [self.view addSubview:instructions];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setTitle:@"Close" forState:UIControlStateNormal];
    close.layer.borderColor = [kLightBlueColor CGColor];
    close.layer.borderWidth  = 1;
    [close setTitleColor:kLightBlueColor forState:UIControlStateNormal];
    [close addTarget:self action:@selector(hideCallingView) forControlEvents:UIControlEventTouchUpInside];
    close.frame = CGRectMake(10, kScreenBounds.size.height-110, kScreenBounds.size.width-20, 40);
    [self.view addSubview:close];
}

-(void) hideCallingView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
