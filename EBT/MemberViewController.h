//
//  MemberViewController.h
//  EBT
//
//  Created by ross chen on 8/15/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "ProviderViewController.h"
@interface MemberViewController : ProviderViewController{
    UIScrollView* contentView;
    BOOL messageRead;
}
@property BOOL isMe;
@end
