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
    [self setNavTitle:@"Damage Control"];
    //[self addRightArrowButton];
    self.navigationItem.leftBarButtonItem = nil;
    
    self.displayList = @[
                         @"Do Not Judge",
                         @"Minimize Harm",
                         @"Know it Will Pass"
                         ];
    
    // Do any additional setup after loading the view from its nib.
    float delta = kiPhone5HeightDelta/2;
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 142, 320, 44)];
    label.numberOfLines = 0;
    label.textColor = kDarkGrayTextColor;
    label.text =  self.displayList[self.currentIndex];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    [Utils applyiPhone4YDelta:-delta forView:label];
    [self.view addSubview:label];
    
      
    float yDelta = -50;
    if (self.currentIndex == self.displayList.count - 1) {
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, 280, 0, 0);
        [button setTitle:@"CONTINUE" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        
        [button setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"greycontinue"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [self setViewFrame:button];
        [Utils applyiPhone4YDelta:yDelta forView:button];
        [self.view addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"SAY IT AGAIN" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(180, 280, 0, 0);
        [button setBackgroundImage:[UIImage imageNamed:@"bluecontinue"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
        [self setViewFrame:button];
        [Utils applyiPhone4YDelta:yDelta forView:button];
        [self.view addSubview:button];
        
    }
    else{
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(160-106/2, 280, 0, 0);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bluecontinue"] forState:UIControlStateNormal];
        [button setTitle:@"CONTINUE" forState:UIControlStateNormal];

        [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [self setViewFrame:button];
        [Utils applyiPhone4YDelta:yDelta forView:button];
        [self.view addSubview:button];
    }

}

-(void)restart{
    Tool5ViewController* vc = [[Tool5ViewController alloc] initWithNibName:@"Tool5ViewController" bundle:nil];
    vc.currentIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];

    /*int count = self.navigationController.viewControllers.count;
    [UIView  beginAnimations:nil context:nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:2];
 [self.navigationController popToViewController:self.navigationController.viewControllers[count-3] animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];   */
}

-(void)next{
    if (self.currentIndex == self.displayList.count - 1) {
        SelectStateViewController* vc = [[SelectStateViewController alloc] initWithNibName:@"SelectStateViewController" bundle:nil];
        vc.isRestartMode = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        Tool5ViewController* vc = [[Tool5ViewController alloc] initWithNibName:@"Tool5ViewController" bundle:nil];
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
