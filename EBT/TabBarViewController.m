//
//  TabBarViewController.m
//  EBT
//
//  Created by Adi on 3/18/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//


#import "TabBarViewController.h"
#import "ConnectionsViewController.h"
#import "MemberViewController.h"
#import "CoursesViewController.h"
#import "MessagesViewController.h"

@implementation TabBarViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTab:0 image:[UIImage imageNamed:@"tab_messages"]],
                            [self viewControllerWithTab:1 image:[UIImage imageNamed:@"tab_connections"]],
                            [self viewControllerWithTab:2 image:nil],
                            [self viewControllerWithTab:3 image:[UIImage imageNamed:@"tab_courses"]],
                            [self viewControllerWithTab:4 image:[UIImage imageNamed:@"tab_profile"]], nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationItem.hidesBackButton = YES;
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tab_state"] highlightImage:[UIImage imageNamed:@"tab_state"]];
    [[(UINavigationController*)self.selectedViewController topViewController] viewWillAppear:animated];
}

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTab:(int) tabIndex image:(UIImage*)image
{
    id navController;
    NSString* title;
    switch (tabIndex) {
        case 0: {
            navController = [[MessagesViewController alloc] init];
            title = @"Messagses";
            break;
        }
        case 1: {
            navController = [[ConnectionsViewController alloc] init];
            title = @"Connections";
            break;
        }
        case 2: {
            navController = [[UIViewController alloc] init];
            title = @"";
            break;
        }
        case 3: {
            navController = [[CoursesViewController alloc] init];
            title = @"Courses";
            break;
        }
        case 4:{
            navController = [[MemberViewController alloc] init];
            [navController setIsMe:YES];
            [navController setCurrentItem:[Utils setting:kUserInfoDict]];
            title = @"Profile";
            break;
        }
        default:
            break;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:navController];
    [nav setTabBarItem:[[UITabBarItem alloc] initWithTitle:title image:image tag:0]];
    return nav;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    if(!self.centerButton) {
        self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.centerButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        self.centerButton.frame = CGRectMake(kScreenBounds.size.width/2 - buttonImage.size.width/2, -20, buttonImage.size.width, buttonImage.size.height);
        [self.centerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self.centerButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        [self.centerButton addTarget:self action:@selector(whatState) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:self.centerButton];
    }
}

-(void)whatState{
    [Utils removeSettingForKey:kInitialState];
    [Utils removeSettingForKey:kCheckinID];
    [Utils showSubViewWithName:@"SelectStateViewController" withDelegate:self];
    
}

@end
