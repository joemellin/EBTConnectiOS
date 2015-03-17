//
//  MessageViewController.h
//  EBT
//
//  Created by ross chen on 8/19/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSMessagesViewController.h"
#import "Utils.h"
@interface MessageViewController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource>{
    UIActivityIndicatorView*  spinner;
	UILabel* loadingLabel;
    NSString* messageSending;
   
}

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property (strong, nonatomic) NSMutableDictionary *currentItem;
@property (strong, nonatomic) NSMutableDictionary* imageCacheDict;
-(BOOL)isOutgoing:(NSDictionary*)dict;
@end
