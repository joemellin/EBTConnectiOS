//
//  AcceptStateViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "AcceptStateViewController.h"

@interface AcceptStateViewController ()

@end

@implementation AcceptStateViewController

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
    [super viewDidLoad];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 50,kScreenBounds.size.width-80, kScreenBounds.size.width-80)];
    imageView.image = [UIImage imageNamed:@"checkinicon"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self.view addSubview:imageView];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = imageView.frame;
    [button addTarget:self action:@selector(fadeToGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 100+kScreenBounds.size.width-80, kScreenBounds.size.width, 160)];
    label.numberOfLines = 0;
    label.textColor = kLightBlueColor;
    label.text =  @"YOU\nCHECKED\nIN!";

    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    [self requestCheckIn];
    
}

-(void)checkin{
    
    [self requestCheckIn];
}



-(IBAction)requestCheckIn{
    if (self.state == [[Utils setting:kInitialState] intValue]) {
        [self performSelector:@selector(fadeToGroup) withObject:nil afterDelay:1];
        return;
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [Utils setting:kSessionToken ],@"auth_token",
                                 nil];
    if ([Utils setting:kCheckinID]) {
        dict[kCheckinID] = [Utils setting:kCheckinID];
        dict[@"final_state"] = [NSString stringWithFormat:@"%d",self.state+1];
    }
    else{
        dict[@"initial_state"] = [NSString stringWithFormat:@"%d",self.state+1];

    }
	NSString* urlStr = [NSString stringWithFormat:@"%@checkins",kBaseURL];
    
    
	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    
	
	MyURLConnection* myconn = [[MyURLConnection alloc] initWithURL:urlStr target:self
												 succeededCallback:@selector(requestSucceeded:myURLConnection:)
													failedCallback:@selector(requestFailed:myURLConnection:)
														   context:[NSNumber numberWithInt:1]];
  
    
    [myconn post:dict];
    
    [self showLoadingView];
	
}


-(void)requestSucceededResultHandler:(id)context result:(NSString*)result{
    NSLog(@"result:%@",result);
    
   if ([context intValue] == 1) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        //[Utils alertMessage:dict[@"success"]];
       if (dict[kCheckinID]) {
           [Utils setSettingForKey:kCheckinID withValue:dict[kCheckinID]];
       }
       [self performSelector:@selector(fadeToGroup) withObject:nil afterDelay:1];
	}
    
    
}

-(void)requestFailedHandlerForError:(NSError*)error forMyURLConnection:(MyURLConnection*)connection{
    [Utils alertMessage:[error localizedDescription]];
    [self fadeToGroup];

}

-(void)fadeToGroup{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToViewController:[[Utils appDelegate] tabBarViewController] animated:YES];
    [self backToGroup];
    /*[ CATransition* transition = [CATransition animation];
    transition.duration = 1.0;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    
   self.navigationController.view.layer
     addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popToViewController:(UIViewController*)[Utils appDelegate].groupController animated:YES];*/


  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
