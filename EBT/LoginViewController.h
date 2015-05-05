//
//  LoginViewController.h
//  EBT
//
//  Created by ross chen on 8/6/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
@interface LoginViewController : BaseRequestViewController{
    UITextField* nameField;
    UITextField* passwordField;
    UIView* logoutContentView;
}

-(void) showController;

@end
