//
//  GroupViewController.m
//  EBT
//
//  Created by ross chen on 8/8/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "GroupViewController.h"
#import "MemberViewController.h"
#import "ProviderViewController.h"
@interface GroupViewController ()

@end

@implementation GroupViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Customization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [self loadImages];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [Utils appDelegate].groupController = self;
    // Do any additional setup after loading the view from its nib.
    [self requestGroup];
    
    //[self setupUI];
}

-(void)setupUI{
    isCoachingGroup = [self.currentItem[@"group_type"][0] isEqualToString:@"coaching"];
    float yOffset = 0;
    if (!kIsiPhone5) {
        yOffset = -30;
    }
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0,yOffset, kScreenBounds.size.width, kIphoneHeight)];
    groupView = contentView;
    [self.view addSubview:contentView];
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, kScreenBounds.size.width, 30)];
    label.numberOfLines = 1;
    label.textColor = kBlueTextColor;
    label.text =  @"Your Provider";
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 200, kScreenBounds.size.width, 30)];
    label.numberOfLines = 1;
    label.textColor = kBlueTextColor;
    label.text =  @"Your Group";
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textAlignment = UITextAlignmentCenter;
    [contentView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 418, kScreenBounds.size.width, 30)];
    [Utils applyiPhone4YDelta:-kiPhone5HeightDelta/2 forView:label];

    label.numberOfLines = 1;
    label.textColor = kBlueTextColor;
    label.text =  @"What is your state?";
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = UITextAlignmentCenter;
    [contentView addSubview:label];
    
   
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 0, 0);
	[button setBackgroundImage:[UIImage imageNamed:@"whatstate"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(whatState) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
    button.center = CGPointMake(160, 495);
    [Utils applyiPhone4YDelta:-50 forView:button];

    [contentView addSubview:button];
    
    float lastY = 0;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    imageView.image = [UIImage imageNamed:@"groupcircle"];
    [self setViewFrame:imageView];
    imageView.center = CGPointMake(160, 80);
    imageView.tag = 0 + kBaseTag;

    [contentView addSubview:imageView];
    
   
    
    float width = 65;
    float height = 65;
    float xDelta1 = 160-85;
    float xDelta2 = 160-44;

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.image = [UIImage imageNamed:@"groupcircle"];
    imageView.center = CGPointMake(160-xDelta1,117);
    imageView.tag = 1 + kBaseTag;

    [contentView addSubview:imageView];
    lastY = imageView.frame.origin.y + imageView.frame.size.height + 5;

    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.image = [UIImage imageNamed:@"groupcircle"];
    imageView.center = CGPointMake(160-xDelta2, 175);
    imageView.tag = 2 + kBaseTag;

    [contentView addSubview:imageView];
    lastY = imageView.frame.origin.y + imageView.frame.size.height + 5;

    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.image = [UIImage imageNamed:@"groupcircle"];
    imageView.center = CGPointMake(160-xDelta2, 250);
    imageView.tag = 3 + kBaseTag;

    [contentView addSubview:imageView];
    lastY = imageView.frame.origin.y + imageView.frame.size.height + 5;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.image = [UIImage imageNamed:@"groupcircle"];
    imageView.center = CGPointMake(160-xDelta1,308);
    imageView.tag = 4 + kBaseTag;
    [contentView addSubview:imageView];
    lastY = imageView.frame.origin.y + imageView.frame.size.height + 5;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.image = [UIImage imageNamed:@"groupcircle"];
    imageView.center = CGPointMake(160,330);
    imageView.tag = 10 + kBaseTag;

    [contentView addSubview:imageView];
    lastY = imageView.frame.origin.y + imageView.frame.size.height + 5;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.image = [UIImage imageNamed:@"groupcircle"];
    imageView.center = CGPointMake(160+xDelta1,308);
    imageView.tag = 8 + kBaseTag;

    [contentView addSubview:imageView];
    
    lastY = imageView.frame.origin.y + imageView.frame.size.height + 5;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.image = [UIImage imageNamed:@"groupcircle"];
    imageView.center = CGPointMake(160+xDelta2, 250);
    imageView.tag = 7 + kBaseTag;
    [contentView addSubview:imageView];
    lastY = imageView.frame.origin.y + imageView.frame.size.height + 5;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.image = [UIImage imageNamed:@"groupcircle"];
    imageView.center = CGPointMake(160+xDelta2, 175);
    imageView.tag = 6 + kBaseTag;

    [contentView addSubview:imageView];
    lastY = imageView.frame.origin.y + imageView.frame.size.height + 5;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.image = [UIImage imageNamed:@"groupcircle"];
    imageView.center = CGPointMake(160+xDelta1,117);
    imageView.tag = 5 + kBaseTag;
    [contentView addSubview:imageView];
    lastY = imageView.frame.origin.y + imageView.frame.size.height + 5;

    for(UIView* view in contentView.subviews){
        if ([view isKindOfClass:[UIImageView class]]) {
            
            UIImageView* iView = (UIImageView*)view;
            [self addBackgroundImageViewForView:iView inParentView:contentView];
            iView.layer.cornerRadius = view.frame.size.width/2;
            iView.clipsToBounds = YES;
            
        }
    }
   
    [self loadImages];




}

-(void)serverErrorHandler{
    [self back];
}

-(void)connectionErrorHandler{
    [self back];
}

-(void)addBackgroundImageViewForView:(UIView*)view inParentView:(UIView*)parentView{
    float border = 4;
    CGRect f = view.frame;
    CGRect newFrame = CGRectMake(f.origin.x+border/2, f.origin.y+border/2, f.size.width-border, f.size.height-border);
    //CGRect oldFrame = view.frame;
    //view.layer.borderColor = [[Utils colorWithRed:230 green:230 blue:230] CGColor];
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    view.layer.borderWidth = 2;
    
    view.userInteractionEnabled = YES;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = view.tag - kBaseTag;
    button.frame = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
    [button addTarget:self action:@selector(showProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    if (button.tag >= 0 && button.tag < 10) {
        NSDictionary* item;
        if (button.tag == 0) {
            item = [self.currentItem objectForKey:kProvider];
            view.layer.borderColor = [kBlueTextColor CGColor];
            
            view.layer.borderWidth = 2;
        }
        else{
            NSArray* otherMembers = [self otherMembers];
            if (button.tag > otherMembers.count ) {
                view.layer.borderColor = [[Utils colorWithRed:230 green:230 blue:230] CGColor];
                
                view.layer.borderWidth = 0.3;
                return;
            }
            item = otherMembers[button.tag-1];
        }
        int messageCount = [item[k_new_message_count] intValue];
        int checkinCount = [item[k_new_checkin_count] intValue];
        //test data
        //checkinCount = 3;
        //messageCount = 3;
        if (checkinCount == 0 && messageCount == 0) {
            return;
        }
       
       
        if (checkinCount > 0) {
            /*UIImageView* imageView = [[UIImageView alloc] initWithFrame:f];
            imageView.image = [UIImage imageNamed:@"groupcircle-green"];
            [parentView insertSubview:imageView belowSubview:view];
            

            view.frame = newFrame;*/
            view.layer.borderColor = [[UIColor greenColor] CGColor];
            view.layer.borderWidth = 2;

        }
        if (messageCount > 0) {
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(newFrame.origin.x + newFrame.size.width-23, newFrame.origin.y, 0, 0)];
            imageView.image = [UIImage imageNamed:@"notificationcircle"];
            imageView.tag = view.tag - kBaseTag + kBaseTag2;
            [self setViewFrame:imageView];
            [parentView addSubview:imageView ];
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
            label.numberOfLines = 1;
            label.textColor = [UIColor whiteColor];
            label.text =  [NSString stringWithFormat:@"%d",messageCount];
            label.backgroundColor= [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            [imageView addSubview:label];
        }

    }
  
    
}

-(void)showProfile:(UIButton*)button{
    UIView* view = [self.view viewWithTag:button.tag + kBaseTag];
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    UIView* view2 = [self.view viewWithTag:button.tag + kBaseTag2];
    [view2 removeFromSuperview];

    NSMutableDictionary* dict;
    if (button.tag == 0) {
        ProviderViewController* vc = [[ProviderViewController alloc] init];
        dict = [self.currentItem objectForKey:kProvider];
        vc.currentItem = dict;
        vc.imageCacheDict = self.imageCacheDict;
        view.layer.borderColor = [kBlueTextColor CGColor];

        [self.navigationController pushViewController:vc animated:YES];


    }
    else if (button.tag == 10) {
        MemberViewController* vc = [[MemberViewController alloc] init];
        vc.isMe = YES ;
        vc.imageCacheDict = self.imageCacheDict;
        if (isCoachingGroup) {
            dict = [self.currentItem objectForKey:kUser];
            vc.currentItem = dict;
        }
        else{
            NSArray* members = [self.currentItem objectForKey:kMembers];
            for(NSMutableDictionary* member in members){
                NSString* name = [member objectForKey:kName];
                if ([name isEqualToString:@"You"]) {
                    dict = member;
                    vc.currentItem = dict;
                    break;
                }
            }
        }
       
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        NSArray* otherMembers = [self otherMembers];
        if (button.tag > otherMembers.count ) {
            return;
        }
        
        MemberViewController* vc = [[MemberViewController alloc] init];
        vc.isMe = NO ;
        vc.imageCacheDict = self.imageCacheDict;
        dict = otherMembers[button.tag-1];
        vc.currentItem = dict;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(NSArray*)otherMembers{
    NSArray* members = [self.currentItem objectForKey:kMembers];

    NSMutableArray* otherMembers = [NSMutableArray arrayWithCapacity:10];
    for(NSDictionary* member in members){
        NSString* name = [member objectForKey:kName];
        
        if ([name isEqualToString:@"You"]) {
            
            
        }
        else{
            [otherMembers addObject:member];
            
            
        }
    }
    return otherMembers;

}

-(void)loadImages{
    if (!self.currentItem) {
        return;
    }
    NSString* url = [[self.currentItem objectForKey:kProvider] objectForKey:kImageURL];
    UIImageView* iView = [self.view viewWithTag:0 + kBaseTag];
    iView.image = [self getImageFromUrlString:url tag:iView.tag];

    
    if (isCoachingGroup) {
        NSString* url = [[self.currentItem objectForKey:kUser] objectForKey:kImageURL];
        UIImageView* iView = [self.view viewWithTag:10 + kBaseTag];
        iView.image = [self getImageFromUrlString:url tag:iView.tag];
        return;
    }
    NSArray* members = [self.currentItem objectForKey:kMembers];
    
    NSMutableArray* otherMembers = [NSMutableArray arrayWithCapacity:10];
    for(NSDictionary* member in members){
        NSString* name = [member objectForKey:kName];
        NSString* url = [member objectForKey:kImageURL];

        if ([name isEqualToString:@"You"]) {
            UIImageView* iView = (UIImageView* )[self.view viewWithTag:10 + kBaseTag];

            iView.image = [self getImageFromUrlString:url tag:10 + kBaseTag];

        }
        else{
            [otherMembers addObject:member];
           

        }
    }
    int idx = 1;
    for(NSDictionary* member in otherMembers){
        NSString* url = [member objectForKey:kImageURL];
        
        
        UIImageView* iView = (UIImageView* )[self.view viewWithTag:idx + kBaseTag];
            
        iView.image = [self getImageFromUrlString:url tag:idx + kBaseTag];
        idx += 1;
            
        
    }
    
}

-(void)whatState{
    [Utils removeSettingForKey:kInitialState];
    [Utils removeSettingForKey:kCheckinID];
    [Utils showSubViewWithName:@"SelectStateViewController" withDelegate:self];
    
}

-(IBAction)requestGroup{
    NSDictionary* dict = [Utils setting:kUserInfoDict];
	NSString* urlStr = [NSString stringWithFormat:@"%@groups/%@",kBaseURL, [[dict objectForKey:kGroup] objectForKey:kID]];
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
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if (dict) {
            self.currentItem = [dict mutableCopy];
            [self setupUI];
        }
        
	}
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
