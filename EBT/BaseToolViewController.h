//
//  Tool3ViewController.h
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
@interface BaseToolViewController : BaseRequestViewController
@property int currentIndex;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *details;
@end
