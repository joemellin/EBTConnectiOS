//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "MessagingData.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking/AFnetworking.h>
#import "HTTPRequestManager.h"

/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

@interface MessagingData() {
    NSDictionary *_currentItem;
}
@end

@implementation MessagingData

- (instancetype)initWithCurrentItem:(NSDictionary*) currentItem
{
    self = [super init];
    if (self) {
        
        _currentItem = currentItem;
        self.messages = [[NSMutableArray alloc] init];
        self.users = @{ [[Utils setting:kUserInfoDict][kID] stringValue] : @"Me",
                        currentItem[kID] : currentItem[kName]
                        };
        [self requestMessages];
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

-(void) loadAvatars {
    JSQMessagesAvatarImage *meImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"ME"
                                                                                  backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                        textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                             font:[UIFont systemFontOfSize:14.0f]
                                                                                        diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    JSQMessagesAvatarImage *otherUser = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"avatar_medium"]
                                                                                   diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    if([_currentItem[kImageURL] hasPrefix:@"http://"]) {
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:_currentItem[kImageURL]]];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.avatars setValue:responseObject forKey:_currentItem[kName]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MessagesUpdated" object:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
    }
    
    self.avatars = @{ [[Utils setting:kUserInfoDict][kID] stringValue] : meImage,
                      [_currentItem[kID] stringValue] : otherUser};
}

-(void)requestMessages{
    HTTPRequestManager *manager = [[HTTPRequestManager alloc] init];
    
    //show loading indicator
    NSString* urlStr = [NSString stringWithFormat:@"%@messages/", kBaseURL];
    [manager.httpOperation GET:urlStr parameters:@{@"other_user_id": _currentItem[kID], @"auth_token": [Utils setting:kSessionToken ]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"error"]) {
            [Utils alertMessage:[responseObject objectForKey:@"error"]];
        }
        
        if([responseObject count]) {
            [self processMessages:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils alertMessage:[error localizedDescription]];
    }];
    
}

-(void) processMessages:(NSArray*) messages {
    NSArray *messagesReversed = [[messages reverseObjectEnumerator] allObjects];
    [self.messages removeAllObjects];
    for(NSDictionary* message in messagesReversed) {
        JSQMessage * jsqMessage = [[JSQMessage alloc] initWithSenderId:[message[kSender][kID] stringValue]
                                                     senderDisplayName:message[kSender][kFname]
                                                                  date:[NSDate distantPast]
                                                                  text:message[kContent]];
        [self.messages addObject:jsqMessage];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessagesUpdated" object:nil];
}

-(void)requestSendMessage:(JSQMessage*)message {
    
    HTTPRequestManager *manager = [[HTTPRequestManager alloc] init];

    NSString* urlStr = [NSString stringWithFormat:@"%@messages",kBaseURL];
    [manager.httpOperation POST:urlStr parameters:@{@"receiver_id": _currentItem[kID], @"auth_token": [Utils setting:kSessionToken ], @"content": message.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"error"]) {
            [Utils alertMessage:[responseObject objectForKey:@"error"]];
        } else {
            [_messages addObject:message];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessagesUpdated" object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils alertMessage:[error localizedDescription]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessagesUpdated" object:nil];
    }];
}

//     [Utils alertMessage:@"This application requires an internet connection to function. Please check your settings."];

@end
