//
//  MemberViewController.m
//  EBT
//
//  Created by ross chen on 8/15/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "MemberViewController.h"
#import "NotificationViewController.h"
#import <UIActionSheet+Blocks.h>
#import <UIImageView+AFNetworking.h>
#import <UIButton+AFNetworking.h>
#import "HTTPRequestManager.h"

@interface MemberViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIImagePickerController *_imagePickerController;
    UIButton *_profileImage;
    UIImageView *_headerImage;
}
@end

@implementation MemberViewController

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
    // Do any additional setup after loading the view from its nib.
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)showMessage{
    messageRead = YES;
    [self setupUI];
    [super showMessage];
}

-(void)setupUI{
    if(contentView) {
        [contentView removeFromSuperview];
    }
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kScreenBounds.size.width, kScreenBounds.size.height-20)];
    contentView.scrollEnabled = YES;
    NSLog(@"FRAME %f %f %f %f", contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height);
    self.navigationItem.hidesBackButton = YES;
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, 10, 0, 0);
	[backButton setBackgroundImage:[UIImage imageNamed:@"groupback"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToGroup) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:backButton];
    [contentView addSubview:backButton];
    
    if (self.isMe) {
        [self addLogoutButtonToView:contentView];

    }
    
    [self.view insertSubview:contentView atIndex:0];
    
    UIView* whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, kScreenBounds.size.width, 130)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];

    
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 0, 0)];
    _headerImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"k%@",self.currentItem[kCourseID]] ];
    [self setViewFrame:_headerImage];
    _headerImage.tag = 0 + kBaseTag;
    
    [contentView addSubview:_headerImage];
    
    _profileImage = [UIButton buttonWithType:UIButtonTypeCustom];
    _profileImage.frame = CGRectMake(103, 23.5, 113, 113);
    _profileImage.tag = 100;
    _profileImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_profileImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.currentItem[kImageURL]]];
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
    _profileImage.clipsToBounds = YES;
    if(_isMe) {
        [_profileImage addTarget:self action:@selector(updateImage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [contentView addSubview:_profileImage];
    
    UILabel* label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 145, kScreenBounds.size.width, 30)];
    label.numberOfLines = 1;
    label.textColor = kDarkGrayTextColor;
    label.text =  self.currentItem[kName];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    
    float lastY = 180;
    UIImageView *profileLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, lastY, 0, 0)];
    profileLine.image = [UIImage imageNamed:@"profileline"];
    [self setViewFrame:profileLine];
    [contentView addSubview:profileLine];
    
    
    if (self.isMe) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100, lastY, 175, 40);
        UIImage *image = [UIImage imageNamed:@"notificationicon"];
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [button setTitle:@"Notifications" forState:UIControlStateNormal];
        [button setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(showNotifications) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    } else {
        profileLine = [[UIImageView alloc] initWithFrame:CGRectMake(160, lastY, 0.5, 40)];
        profileLine.image = [UIImage imageNamed:@"profileline2"];
        [contentView addSubview:profileLine];
        
        int messageCount = [self.currentItem[k_new_message_count] intValue];
        //messageCount = 3;
        if (messageCount > 0 && !messageRead) {
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(175,lastY+8, 0, 0)];
            imageView.image = [UIImage imageNamed:@"notificationcircle"];
            [self setViewFrame:imageView];
            [contentView addSubview:imageView ];
            
            UILabel* label = [[UILabel alloc] initWithFrame:imageView.frame];
            label.numberOfLines = 1;
            label.textColor = [UIColor whiteColor];
            label.text =  [NSString stringWithFormat:@"%d",messageCount];
            label.backgroundColor= [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            [contentView addSubview:label];


        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(200, lastY, 175, 40);
        UIImage *image = [UIImage imageNamed:@"messageicon"];
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(2, 10, 0, 0);
        [button setTitle:@"Message" forState:UIControlStateNormal];
        [button setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(showMessage) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, lastY, 175, 40);
        image = [UIImage imageNamed:@"heart"];
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(2, 10, 0, 0);
        [button setTitle:@"Support" forState:UIControlStateNormal];
        [button setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(support) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];

    }
   
    
    
    profileLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, lastY+40, 0, 0)];
    profileLine.image = [UIImage imageNamed:@"profileline"];
    [self setViewFrame:profileLine];
    
    [contentView addSubview:profileLine];
    
    lastY = profileLine.frame.origin.y + profileLine.frame.size.height + 20;
    
    [self addTimelineToParentView:contentView fromY:lastY];
        
    
    
}

-(NSString*)timelineXValueForCheckin:(NSDictionary*)item{
    NSDate* date = [Utils dateFromISOString:item[kDate]];
    if (item[kSupporterID]) {
        date = [Utils dateFromISOString:item[@"supported_at"]];
    }
    int delta = abs((int)[date timeIntervalSinceNow]);
    int hour = delta / 3600;
    int min = (((int)delta) % 3600) / 60;
    if (hour > 0) {
        /*if (hour > 48) {
            return @"2 days ago";
        }
        if (hour > 24) {
            hour = hour - 24;
            return [NSString stringWithFormat:@"1day%dh",hour];
        }*/
        return [NSString stringWithFormat:@"%dh",hour];
    }
    else if (min > 0) {
        return [NSString stringWithFormat:@"%dmin",min];

    }
    else{
        return @"Now";
    }
}

-(NSDate*)dateFromItem:(NSDictionary*)item{
    NSDate* date = [Utils dateFromISOString:item[kDate]];
    if (item[kSupporterID]) {
        date = [Utils dateFromISOString:item[@"supported_at"]];
    }
    return date;

}

-(void)showSupporter:(UIButton*)button{
    NSDictionary* item = self.displayList[button.tag];
    MemberViewController* vc = [[MemberViewController alloc] init];
    NSDictionary* dict = [Utils setting:kUserInfoDict];
    vc.isMe = [dict[kID] isEqualToNumber:item[kID]] ;
    vc.imageCacheDict = self.imageCacheDict;
    vc.currentItem = item;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addTimelineToParentView:(UIScrollView*)contentViewBig fromY:(float)lastY{
    NSMutableArray* list = [self.currentItem[kCheckins] mutableCopy];
    
    if (self.currentItem[kSupporters]) {
        if (!list) {
            list = [NSMutableArray arrayWithCapacity:10];
        }
        NSArray* list2 = self.currentItem[kSupporters];
        NSMutableArray* list3 = [NSMutableArray arrayWithCapacity:10];
        for(NSDictionary* dict in list2){
            NSMutableDictionary* dict2 = [dict mutableCopy];
            dict2[kDate] = dict[@"supported_at"];
            [list3 addObject:dict2];
        }
        [list addObjectsFromArray:list3];
        
    }
    if ([list count] == 0) {
        return;
    }
    [list sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:kDate ascending:YES]]];
    self.displayList = list;
    
    NSDictionary* firstItem = [list objectAtIndex:0];
    
    NSDate* date0 = [self dateFromItem:firstItem];

    int duration = (int)[[NSDate date] timeIntervalSinceDate:date0];
    int days = duration / (24*3600);
    days += 1;
    if (duration % (24*3600) == 0) {
        days -= 1;
    }
    NSDate* startDate = [[NSDate date] dateByAddingTimeInterval:- days * 24*3600 +2*3600];
    float widthPerSecond = kScreenBounds.size.width/(24*3600);
    
    /* int col = 5;
     int row = list.count / col + 1;
     if (list.count % 5 == 0) {
     row -= 1;
     }*/
    
    float yDistance = 196;
    float circleHeight = 45;
    float ovalHeight = 110;
    float badgeHeight = 68;
    float itemWidth = 45;
    //float distance = 290/col;
    float lastContentY = 0;
    float firstY = lastY;
    
    UIScrollView* contentViewMember = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lastY, kScreenBounds.size.width, 250)];
    contentViewMember.scrollEnabled = YES;
    contentViewMember.pagingEnabled = YES;

    [contentViewBig addSubview:contentViewMember];
    lastY = 10;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  lastY+yDistance-10, days * kScreenBounds.size.width-3 , 21)];
    lastContentY = firstY + 20 + 30 ;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.cornerRadius = 10;
    imageView.clipsToBounds = YES;
    
    //imageView.image = [UIImage imageNamed:@"timeline"];
    //[self setViewFrame:imageView];
    [contentViewMember addSubview:imageView];
    UIImageView* timelineView = imageView;
    
    float lastLabelX = 0;
    
    for(int i=0; i < [list count]; i++){

        float lastX = 0;
        
        NSDictionary* item = list[i];
        NSDate* date = [self dateFromItem:item];
        NSTimeInterval delta = [date timeIntervalSinceDate:startDate];
        lastX = delta * widthPerSecond;
        if(item[@"supporter_image_url"]){
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            imageView.image = [UIImage imageNamed:@"yellowbadge" ];
            
            [self setViewFrame:imageView];
            imageView.center = CGPointMake(lastX , lastY+yDistance - badgeHeight );
            [contentViewMember addSubview:imageView];
            
            float lastY2 = imageView.frame.origin.y + imageView.frame.size.height + 3 ;
            
            UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 28, 28)];
            imageView2.layer.cornerRadius = imageView2.frame.size.width/2;
            imageView2.clipsToBounds = YES;
            imageView2.tag = 999;
            [imageView2 setImageWithURL:[NSURL URLWithString:item[@"supporter_image_url"]]];
            [imageView addSubview:imageView2];
            
            
            imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(13, 60, 0, 0)];
            imageView2.image = [UIImage imageNamed:@"heartwhite" ];
            [self setViewFrame:imageView2];
            [imageView addSubview:imageView2];
            
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = imageView.frame;
            button.tag = i;
            [button addTarget:self action:@selector(showSupporter:) forControlEvents:UIControlEventTouchUpInside];
            [contentViewMember addSubview:button];

            
            
            UILabel* label;
            
            if (imageView.frame.origin.x > lastLabelX) {

                label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+2, lastY2+9, itemWidth, 20)];
                label.numberOfLines = 1;
                label.textColor = kDarkGrayTextColor;
                label.text =  [self timelineXValueForCheckin:item];
                label.backgroundColor= [UIColor clearColor ];
                label.font = [UIFont systemFontOfSize:14];
                label.textAlignment = NSTextAlignmentCenter;
                [contentViewMember addSubview:label];
                lastLabelX = label.frame.origin.x + label.frame.size.width+5;
            }
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + 23 , lastY2-2, 0, 0)];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@stick",@"yellow"] ];
            [self setViewFrame:imageView];
            //[contentView insertSubview:imageView atIndex:0];
            [contentViewMember insertSubview:imageView belowSubview:timelineView];
        }
        else{
            
            if ([item[kFinalState] isKindOfClass:[NSNull class]]) {
                NSString* color = @"";
                UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                if ([item[kInitialState] intValue] == 1) {
                    
                    color = @"yellow";
                }
                else{
                    color = @"grey";
                }
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@circle",color] ];
                
                [self setViewFrame:imageView];
                imageView.center = CGPointMake(lastX , lastY+yDistance - circleHeight );
                [contentViewMember addSubview:imageView];
                
                float lastY2 = imageView.frame.origin.y + imageView.frame.size.height + 3 ;
                
                
                UILabel* label;
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
                label.numberOfLines = 1;
                label.textColor = [UIColor whiteColor];
                label.text =  [NSString stringWithFormat:@"%@",item[kInitialState]];
                label.backgroundColor= [UIColor clearColor ];
                label.font = [UIFont boldSystemFontOfSize:25];
                label.textAlignment = NSTextAlignmentCenter;
                [imageView addSubview:label];

                if (imageView.frame.origin.x > lastLabelX) {
                    label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, lastY2+10, itemWidth, 20)];
                    label.numberOfLines = 1;
                    label.textColor = kDarkGrayTextColor;
                    label.text =  [self timelineXValueForCheckin:item];
                    label.backgroundColor= [UIColor clearColor ];
                    label.font = [UIFont systemFontOfSize:14];
                    label.textAlignment = NSTextAlignmentCenter;
                    [contentViewMember addSubview:label];
                    lastLabelX = label.frame.origin.x + label.frame.size.width+5;
                }
                

                
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + 20 , lastY2, 0, 0)];
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@stick",color] ];
                [self setViewFrame:imageView];
                //[contentView insertSubview:imageView atIndex:0];
                [contentViewMember insertSubview:imageView belowSubview:timelineView];

                
                
                
            }
            else{
                NSString* color = @"";
                UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                if ([item[kFinalState] intValue] == 1) {
                    
                    color = @"yellow";
                }
                else{
                    color = @"blue";
                }
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@oval",color] ];
                
                [self setViewFrame:imageView];
                imageView.center = CGPointMake(lastX , lastY+yDistance - ovalHeight );
                [contentViewMember addSubview:imageView];
                float lastY2 = imageView.frame.origin.y + imageView.frame.size.height;
                float itemX = imageView.frame.origin.x;
                
                UILabel* label;
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, imageView.frame.size.width, 20)];
                label.numberOfLines = 1;
                label.textColor = [UIColor whiteColor];
                label.text =  [NSString stringWithFormat:@"%@",item[kFinalState]];
                label.backgroundColor= [UIColor clearColor ];
                label.font = [UIFont boldSystemFontOfSize:25];
                label.textAlignment = NSTextAlignmentCenter;
                [imageView addSubview:label];
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, imageView.frame.size.width, 20)];
                label.numberOfLines = 1;
                label.textColor = [UIColor whiteColor];
                label.text =  [NSString stringWithFormat:@"%@",item[kInitialState]];
                label.backgroundColor= [UIColor clearColor ];
                label.font = [UIFont boldSystemFontOfSize:25];
                label.textAlignment = NSTextAlignmentCenter;
                [imageView addSubview:label];
                
                UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 45, 0, 0)];
                imageView2.image = [UIImage imageNamed:@"verticalarrow"];
                [self setViewFrame:imageView2];
                [imageView addSubview:imageView2];
                
                if (imageView.frame.origin.x > lastLabelX) {

                    label = [[UILabel alloc] initWithFrame:CGRectMake(itemX, lastY2+10, itemWidth, 20)];
                    label.numberOfLines = 1;
                    label.textColor = kDarkGrayTextColor;
                    label.text =  [self timelineXValueForCheckin:item];
                    label.backgroundColor= [UIColor clearColor ];
                    label.font = [UIFont systemFontOfSize:14];
                    label.textAlignment = NSTextAlignmentCenter;
                    [contentViewMember addSubview:label];
                    lastLabelX = label.frame.origin.x + label.frame.size.width+5;
                }

                
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + itemWidth/2 , lastY2, 0, 0)];
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@stick",color] ];
                [self setViewFrame:imageView];
                //[contentView insertSubview:imageView atIndex:0];
                [contentViewMember insertSubview:imageView belowSubview:timelineView];

                
            }
            
        }
        
    }
    contentViewMember.contentSize = CGSizeMake(days*kScreenBounds.size.width, 250);
    
   
    contentViewBig.contentSize = CGSizeMake(kScreenBounds.size.width, lastContentY+50);
    
    [contentViewMember scrollRectToVisible:CGRectMake(days*kScreenBounds.size.width-10, 10, 10, 10) animated:NO ];
}

-(void)showNotifications{
    NotificationViewController* vc = [[NotificationViewController alloc] init];
    vc.displayList = [self.currentItem objectForKey:kSupporters];
    vc.imageCacheDict = self.imageCacheDict;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)support{
    [self requestSupport];
}

-(IBAction)requestSupport{
	NSString* urlStr = [NSString stringWithFormat:@"%@mobile_supports",kBaseURL];
    
    
	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    
	
	MyURLConnection* myconn = [[MyURLConnection alloc] initWithURL:urlStr target:self
												 succeededCallback:@selector(requestSucceeded:myURLConnection:)
													failedCallback:@selector(requestFailed:myURLConnection:)
														   context:[NSNumber numberWithInt:2]];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%@",self.currentItem[kID]],@"supported_user_id",
                          [Utils setting:kSessionToken ],@"auth_token",
                          nil];
    
    [myconn post:dict];
    
    [self showLoadingView];
	
}

-(IBAction)requestUserInfo{
    //test data
    //[self requestSucceededResultHandler:@"1" result:@""];return;
    
    
    NSDictionary* dict = [Utils setting:kUserInfoDict];
    NSString* urlStr = [NSString stringWithFormat:@"%@users/%@?auth_token=%@",kBaseURL, self.currentItem[kID], [Utils setting:kSessionToken]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    
	
	MyURLConnection* myconn = [[MyURLConnection alloc] initWithURL:urlStr target:self
												 succeededCallback:@selector(requestSucceeded:myURLConnection:)
													failedCallback:@selector(requestFailed:myURLConnection:)
														   context:[NSNumber numberWithInt:1]];
    [myconn get];
    [self showLoadingView];
	
}

-(void)requestSucceededResultHandler:(id)context result:(NSString*)result{
    NSLog(@"result:%@",result);
    
    
    
	if ([context intValue] == 1) {
        //test data
        //result = [Utils stringFromFileNamed:@"member.json"];
        NSDictionary* dict0 = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if (dict0) {
            NSMutableDictionary* dict = [dict0 mutableCopy];
            //dict[k_new_checkin_count] = currentItem[k_new_checkin_count];
            //dict[k_new_message_count] =  currentItem[k_new_message_count];
            self.currentItem = dict;
            [self setupUI];
        }
        
	}
    else if ([context intValue] == 2) {
        //[Utils alertMessage:[NSString stringWithFormat:@"You have supported %@!",currentItem[kName] ]];
        [self requestUserInfo];
    }
    
    
}

-(void)loadingViewHanlder:(int)context{
    if (context == 2) {
        return;
    }
	[self hideLoadingView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - camera controller
-(void) updateImage {
    [UIActionSheet showInView:self.view
                    withTitle:@"Select an Image"
            cancelButtonTitle:@"Cancel"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"Take Photo", @"Choose Existing Photo"]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         if(buttonIndex == 0) {
                             [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
                         } else if(buttonIndex == 1){
                             [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                         }
                         NSLog(@"Chose %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
                     }];
    
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if(sourceType == UIImagePickerControllerSourceTypeCamera && !isCameraAvailable ) {
        NSLog(@"Camera not available");
    } else {
        _imagePickerController.sourceType = sourceType;
        
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *scaled = [self imageWithImage:image scaledToFillSize:CGSizeMake(1000, 1000)];
    [_profileImage setImage:scaled forState:UIControlStateNormal];
    NSData *imageData = UIImageJPEGRepresentation(scaled, 1.0);
    [self performSelector:@selector(uploadImage:) withObject:imageData];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void) uploadImage:(NSData*) image {
    NSString* imagePostUrl = [NSString stringWithFormat:@"%@users/%@?auth_token=%@",kBaseURL, self.currentItem[kID], [Utils setting:kSessionToken]];
    
    
    [self showLoadingView];
    HTTPRequestManager *manager = [[HTTPRequestManager alloc] init];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"PATCH" URLString:imagePostUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:image
                                    name:@"user[avatar]"
                                fileName:@"avatar.jpeg" mimeType:@"image/jpeg"];
    } error:nil];
    
    AFHTTPRequestOperation *requestOperation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils alertMessage:[error localizedDescription]];
        [self hideLoadingView];
    }];
    
    // fire the request
    [requestOperation start];
}

@end
