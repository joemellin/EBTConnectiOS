//
//  StateDetailViewController.h
//  EBT
//
//  Created by ross chen on 8/13/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
@interface StateDetailViewController : BaseRequestViewController{
    NSArray* titles;
    NSArray* results;
    NSArray* details;
}
@property int state;
@end
