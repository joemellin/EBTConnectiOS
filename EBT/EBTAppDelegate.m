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
#import "GroupViewController.h"
#import "Tool2S2ViewController.h"
#import "LoginViewController.h"

#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"
#import "TabBarViewController.h"


@implementation EBTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    config.detectProvisioningMode = true;
    // You can also programatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    // Request a custom set of notification types
    [UAPush shared].userNotificationTypes = (UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert 
                                    );
    
    
    UIImage* myImage = [UIImage imageNamed:@"navbar.png"];
    [[UINavigationBar appearance] setBackgroundImage:myImage forBarMetrics:UIBarMetricsDefault];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[EBTViewController alloc] initWithNibName:@"EBTViewController" bundle:nil];
    //test data
    //[Utils removeSettingForKey:kLoginInfoDict];
    
    [Utils removeSettingForKey:kLoginBackTapped];
    
    UIViewController* vc = [[OpeningViewController alloc] initWithNibName:@"OpeningViewController" bundle:nil];
//    vc = [[TabBarViewController alloc] init];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBarHidden = YES;

    self.window.rootViewController = nvc;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    [Utils alertMessage:[NSString stringWithFormat:@"My token is: %@", deviceToken]];
	NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
	token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
	self.deviceTokenFromApple = token;
    [self registerPushNotificationOnSTServer];
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
