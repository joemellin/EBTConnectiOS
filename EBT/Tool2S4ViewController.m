//
//  Tool2S4ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "Tool2S4ViewController.h"
#import "SelectStateViewController.h"
@interface Tool2S4ViewController ()

@end

@implementation Tool2S4ViewController

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
    [self setNavTitle:@"Feelings Check"];
    [self addRightArrowButton];

    // Do any additional setup after loading the view from its nib.
    float delta = kiPhone5HeightDelta/2;
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 110, 320, 66)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text =  [NSString stringWithFormat:@"Your strongest feeling is...\n\n%@",[Utils setting:kSelectedFeeling]];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = UITextAlignmentCenter;
    [Utils applyiPhone4YDelta:-delta forView:label];
    [self.view addSubview:label];
    
    NSString* text = @"Ask yourself: \nWhat do you need?";
    UIFont* font = [UIFont systemFontOfSize:17];
    float h = [Utils heightWithText:text andFont:font andMaxWidth:kScreenBounds.size.width-20];
    label = [[UILabel alloc] initWithFrame:CGRectMake(10 , 270, 300, h)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text =  text;
    label.backgroundColor= [UIColor clearColor];
    label.font = font;
    label.textAlignment = UITextAlignmentCenter;
    [Utils applyiPhone4YDelta:-delta forView:label];

    [self.view addSubview:label];
    
}


-(void)next{
    SelectStateViewController* vc = [[SelectStateViewController alloc] initWithNibName:@"SelectStateViewController" bundle:nil];
    vc.isRestartMode = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
