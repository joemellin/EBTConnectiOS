//
//  EBTAppDelegate.h
//  EBT
//
//  Created by ross chen on 8/2/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBTViewController;
@class GroupViewController;
@class LoginViewController;
@class TabBarViewController;

@interface EBTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString* deviceTokenFromApple;
@property (strong, nonatomic)NSString* sessionID;
@property (strong, nonatomic) EBTViewController *viewController;
@property (strong, nonatomic) GroupViewController *groupController;
@property (strong, nonatomic) GroupViewController *loginViewController;
@property (strong, nonatomic) TabBarViewController *tabBarViewController;
@end
