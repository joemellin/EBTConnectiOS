//
//  MemberViewController.m
//  EBT
//
//  Created by ross chen on 8/15/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "MemberViewController.h"
#import "NotificationViewController.h"

@interface MemberViewController ()

@end

@implementation MemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)showMessage{
    messageRead = YES;
    [self setupUI];
    [super showMessage];
}

-(void)setupUI{
    if (contentView) {
        [contentView removeFromSuperview];
    }
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, kScreenBounds.size.height)];
    contentView.scrollEnabled = YES;
    
    self.navigationItem.hidesBackButton = YES;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 10, 0, 0);
	[button setBackgroundImage:[UIImage imageNamed:@"groupback"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToGroup) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
    [contentView addSubview:button];
    
    if (self.isMe) {
        [self addLogoutButtonToView:contentView];

    }
    
    [self.view insertSubview:contentView atIndex:0];
    
    UIView* whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, kScreenBounds.size.width, 130)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];

    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 0, 0)];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"k%@",self.currentItem[kCourseID]] ];
    [self setViewFrame:imageView];
    imageView.tag = 0 + kBaseTag;
    
    [contentView addSubview:imageView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(103, 23.5, 113, 113)];
    imageView.tag = 100;
    imageView.image = [self getImageFromUrlString:self.currentItem[kImageURL] tag:imageView.tag];
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.clipsToBounds = YES;
    
    [contentView addSubview:imageView];
    
    UILabel* label;
    /*
    label = [[UILabel alloc] initWithFrame:CGRectMake(35 , 73, 60, 17)];
    label.numberOfLines = 1;
    label.textColor = [UIColor whiteColor];
    label.text =  @"Kit4";
    label.backgroundColor= [UIColor clearColor ];
    label.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(240 , 73, 60, 17)];
    label.numberOfLines = 1;
    label.textColor = [UIColor whiteColor];
    label.text =  @"Integrity";
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:label];*/


    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 145, 320, 30)];
    label.numberOfLines = 1;
    label.textColor = kDarkGrayTextColor;
    label.text =  self.currentItem[kName];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    
    float lastY = 180;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lastY, 0, 0)];
    imageView.image = [UIImage imageNamed:@"profileline"];
    [self setViewFrame:imageView];
    [contentView addSubview:imageView];
    
    
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
        

    }
    else{
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, lastY, 0.5, 40)];
        imageView.image = [UIImage imageNamed:@"profileline2"];
        //[self setViewFrame:imageView];
        [contentView addSubview:imageView];
        
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
   
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lastY+40, 0, 0)];
    imageView.image = [UIImage imageNamed:@"profileline"];
    [self setViewFrame:imageView];
    
    [contentView addSubview:imageView];
    
    lastY = imageView.frame.origin.y + imageView.frame.size.height + 20;
    
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
    MemberViewController* vc = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:nil];
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
    
    NSDictionary* lastItem = [list lastObject];
    NSDictionary* firstItem = [list objectAtIndex:0];
    NSDate* date = [self dateFromItem:lastItem];

    
    NSDate* date0 = [self dateFromItem:firstItem];

    int duration = (int)[[NSDate date] timeIntervalSinceDate:date0];
    int days = duration / (24*3600);
    days += 1;
    if (duration % (24*3600) == 0) {
        days -= 1;
    }
    NSDate* startDate = [[NSDate date] dateByAddingTimeInterval:- days * 24*3600 +2*3600];
    float widthPerSecond = 320.0f/(24*3600);
    
    /* int col = 5;
     int row = list.count / col + 1;
     if (list.count % 5 == 0) {
     row -= 1;
     }*/
    
    float yDistance = 196;
    float circleHeight = 45;
    float ovalHeight = 110;
    float badgeHeight = 68;
    //NSArray* xValues = @[@"",@"",@"",@"",@""];
    float timelineWidth = kScreenBounds.size.width;
    float itemWidth = 45;
    //float distance = 290/col;
    float lastContentY = 0;
    float firstY = lastY;
    
    UIScrollView* contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lastY, 320, 250)];
    contentView.scrollEnabled = YES;
    contentView.pagingEnabled = YES;

    [contentViewBig addSubview:contentView];
    lastY = 10;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  lastY+yDistance-10, days * 320-3 , 21)];
    lastContentY = firstY + 20 + 30 ;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.cornerRadius = 10;
    imageView.clipsToBounds = YES;
    
    //imageView.image = [UIImage imageNamed:@"timeline"];
    //[self setViewFrame:imageView];
    [contentView addSubview:imageView];
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
            [contentView addSubview:imageView];
            
            float lastY2 = imageView.frame.origin.y + imageView.frame.size.height + 3 ;
            
            UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 28, 28)];
            imageView2.layer.cornerRadius = imageView2.frame.size.width/2;
            imageView2.clipsToBounds = YES;
            imageView2.tag = 999;
            imageView2.image = [self getImageFromUrlString:item[@"supporter_image_url"] tag:imageView2.tag];
            [imageView addSubview:imageView2];
            
            
            imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(13, 60, 0, 0)];
            imageView2.image = [UIImage imageNamed:@"heartwhite" ];
            [self setViewFrame:imageView2];
            [imageView addSubview:imageView2];
            
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = imageView.frame;
            button.tag = i;
            [button addTarget:self action:@selector(showSupporter:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:button];

            
            
            UILabel* label;
            
            if (imageView.frame.origin.x > lastLabelX) {

                label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+2, lastY2+9, itemWidth, 20)];
                label.numberOfLines = 1;
                label.textColor = kDarkGrayTextColor;
                label.text =  [self timelineXValueForCheckin:item];
                label.backgroundColor= [UIColor clearColor ];
                label.font = [UIFont systemFontOfSize:14];
                label.textAlignment = UITextAlignmentCenter;
                [contentView addSubview:label];
                lastLabelX = label.frame.origin.x + label.frame.size.width+5;
            }
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + 23 , lastY2-2, 0, 0)];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@stick",@"yellow"] ];
            [self setViewFrame:imageView];
            //[contentView insertSubview:imageView atIndex:0];
            [contentView insertSubview:imageView belowSubview:timelineView];
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
                [contentView addSubview:imageView];
                
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
                    [contentView addSubview:label];
                    lastLabelX = label.frame.origin.x + label.frame.size.width+5;
                }
                

                
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + 20 , lastY2, 0, 0)];
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@stick",color] ];
                [self setViewFrame:imageView];
                //[contentView insertSubview:imageView atIndex:0];
                [contentView insertSubview:imageView belowSubview:timelineView];

                
                
                
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
                [contentView addSubview:imageView];
                float lastY2 = imageView.frame.origin.y + imageView.frame.size.height;
                float itemX = imageView.frame.origin.x;
                
                UILabel* label;
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, imageView.frame.size.width, 20)];
                label.numberOfLines = 1;
                label.textColor = [UIColor whiteColor];
                label.text =  [NSString stringWithFormat:@"%@",item[kFinalState]];
                label.backgroundColor= [UIColor clearColor ];
                label.font = [UIFont boldSystemFontOfSize:25];
                label.textAlignment = UITextAlignmentCenter;
                [imageView addSubview:label];
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, imageView.frame.size.width, 20)];
                label.numberOfLines = 1;
                label.textColor = [UIColor whiteColor];
                label.text =  [NSString stringWithFormat:@"%@",item[kInitialState]];
                label.backgroundColor= [UIColor clearColor ];
                label.font = [UIFont boldSystemFontOfSize:25];
                label.textAlignment = UITextAlignmentCenter;
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
                    label.textAlignment = UITextAlignmentCenter;
                    [contentView addSubview:label];
                    lastLabelX = label.frame.origin.x + label.frame.size.width+5;
                }

                
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + itemWidth/2 , lastY2, 0, 0)];
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@stick",color] ];
                [self setViewFrame:imageView];
                //[contentView insertSubview:imageView atIndex:0];
                [contentView insertSubview:imageView belowSubview:timelineView];

                
            }
            
        }
        
    }
    contentView.contentSize = CGSizeMake(days*320, 250);
    
   
    contentViewBig.contentSize = CGSizeMake(320, lastContentY+50);
    
    [contentView scrollRectToVisible:CGRectMake(days*320-10, 10, 10, 10) animated:NO ];
}

-(void)showNotifications{
    NotificationViewController* vc = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
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
	NSString* urlStr = [NSString stringWithFormat:@"%@users/%@",kBaseURL, self.currentItem[kID] ];
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

@end
