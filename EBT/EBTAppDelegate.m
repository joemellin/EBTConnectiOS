//
//  EBTAppDelegate.m
//  EBT
//
//  Created by ross chen on 8/2/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "EBTAppDelegate.h"

#import "EBTViewController.h"
#import "OpeningViewController.h"
#import "Tool2S2ViewController.h"
#import "LoginViewController.h"

#import "TabBarViewController.h"
#import "CustomNavigationController.h"
#import <Parse/Parse.h>
#import "HTTPRequestManager.h"

@implementation EBTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"zeL64do78roAYYMmsOA7HRWzb8eSXNHDV0txV0Kh" clientKey:@"0G2x6pQFjNd32HXCJl793jAp7gNgyGyKBYi90sQt"];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:settings];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:71/255.0f green:138/255.0f blue:198/255.0f alpha:1.0], NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0]];
    
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"transparentShadow.png"]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage imageNamed:@"tabbarbackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 0, 0)]];
    [[UITabBar appearance] setSelectedImageTintColor:kBlueTabColor];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[EBTViewController alloc] init];
    //test data
    //[Utils removeSettingForKey:kLoginInfoDict];
    
    [Utils removeSettingForKey:kLoginBackTapped];
    
    UIViewController* vc = [[OpeningViewController alloc] init];
    CustomNavigationController* nvc = [[CustomNavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBarHidden = YES;

    self.window.rootViewController = nvc;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
	NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
	token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
	self.deviceTokenFromApple = token;
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    [Utils setSettingForKey:@"notification_token" withValue:self.deviceTokenFromApple];
    [Utils setSettingForKey:@"installation_id" withValue:currentInstallation.installationId];
    
    [self sendNotificationToken];
}

-(void) sendNotificationToken {
    if([Utils setting:kSessionToken]) {
        NSString* urlStr = [NSString stringWithFormat:@"%@devices?auth_token=%@",kBaseURL, [Utils setting:kSessionToken]];
        HTTPRequestManager *manager = [[HTTPRequestManager alloc] init];
        
        NSDictionary *params = @{@"device_token":[Utils setting:@"notification_token"], @"installation_id": [Utils setting:@"installation_id"]};
        
        [manager.httpOperation POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"error"]) {
                [Utils alertMessage:[responseObject objectForKey:@"error"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Utils alertMessage:[error localizedDescription]];
        }];
    }
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMessageScreens" object:nil];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

-(void)retry
{
	[self performSelector:@selector(registerPushNotificationOnSTServer)
			   withObject:nil
			   afterDelay:5];
}

-(void)registerPushNotificationOnSTServer
{
    self.sessionID = [Utils setting:kSessionToken ];
	if (!self.sessionID || !self.deviceTokenFromApple) {
		[self retry];
		return;
	}
	
	NSString* urlStr = [NSString stringWithFormat:@"%@devices/register_device",kBaseURL];
    
    
	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    
	
	MyURLConnection* myconn = [[MyURLConnection alloc] initWithURL:urlStr target:self
												 succeededCallback:@selector(requestSucceeded:myURLConnection:)
													failedCallback:@selector(requestFailed:myURLConnection:)
														   context:[NSNumber numberWithInt:2]];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.deviceTokenFromApple,@"device_token",
                          self.sessionID,@"auth_token",
                          nil];
    NSLog(@"dict:%@", dict);
    
    [myconn post:dict];
}


-(void)requestSucceeded:(NSString*)result myURLConnection:(MyURLConnection*)connection
{
	int statuCode = connection.statusCode;
	if(statuCode != 200){
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([dict objectForKey:@"error"]) {
            [Utils alertMessage:[dict objectForKey:@"error"]];
        }
        else{
            [Utils alertMessage:[NSString stringWithFormat:@"Request error:%d\n%@", statuCode,connection.requestURL]];
            
        }
		return;
	}
    NSLog(@"devicetoken registered");
	
	
	
}

-(void)requestFailed:(NSError*)error myURLConnection:(MyURLConnection*)connection
{
	[self retry];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if([vc isKindOfClass:[UINavigationController class]]) {
        if ([[(UINavigationController*)vc topViewController] respondsToSelector:@selector(hideCallingView)]) {
            [[(UINavigationController*)vc topViewController] performSelector:@selector(hideCallingView) withObject:nil];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
