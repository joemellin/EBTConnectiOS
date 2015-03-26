//
//  CallingViewController.h
//  EBT
//
//  Created by Adi on 3/26/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRequestViewController.h"

@interface CallingViewController : BaseRequestViewController
@property (nonatomic, strong) NSString *name;
-(void) hideCallingView;
@end
