//
//  UIView+FirstResponder.m
//  Giftmeister
//
//  Created by Ross Chen on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIView+FirstResponder.h"



@implementation UIView (FindAndResignFirstResponder)
- (BOOL)findAndResignFirstResonder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResonder])
            return YES;
    }
    return NO;
}
@end

