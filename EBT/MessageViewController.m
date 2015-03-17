//
//  MessageViewController.m
//  EBT
//
//  Created by ross chen on 8/19/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "MessageViewController.h"


@interface MessageViewController ()

@end

@implementation MessageViewController
@synthesize imageCacheDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Initialization
- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"sendmessage"] forState:UIControlStateNormal];
    return button;
    //return [UIButton defaultSendButton];
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
   
}

-(void)back{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)setNavTitle:(NSString*)title{
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, 250, 42)];
    label.numberOfLines = 1;
    label.textColor = kGrayTextColor;
    label.text =  title;
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(1.0f, 0.0f);
    //label.layer.shadowOpacity = 1.0f;
    //label.layer.shadowRadius = 1.0f;
    label.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = label;
}
-(void)addLeftBackButton{
    
    self.navigationItem.hidesBackButton = YES;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 0, 0);
	[button setBackgroundImage:[UIImage imageNamed:@"graybackbutton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

-(void)setViewFrame:(UIView*)view{
	CGRect f = view.frame;
	UIImage* image = nil;
	if ([view isKindOfClass:[UIImageView class]]) {
		image = ((UIImageView*)view).image;
	}
	else if ([view isKindOfClass:[UIButton class]]) {
		image = [((UIButton*)view) imageForState:UIControlStateSelected];
        if (!image) {
            image = [((UIButton*)view) backgroundImageForState:UIControlStateSelected];
            
        }
	}
	view.frame = CGRectMake(f.origin.x, f.origin.y, image.size.width/2, image.size.height/2);
	
}

-(void)showLoadingView{
	[self.view bringSubviewToFront:loadingLabel];
	[self.view bringSubviewToFront:spinner];
	loadingLabel.hidden =NO;
    spinner.hidden = NO;
	[spinner startAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)hideLoadingView{
	loadingLabel.hidden =YES;
	
	[spinner stopAnimating];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)showRightLoading{
    
	UIActivityIndicatorView* aiview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	aiview.frame =CGRectMake(0, 0, 20, 20);
	[aiview startAnimating];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aiview] ;

}

-(void)hideRightLoading{
	self.navigationItem.rightBarButtonItem = nil;
}


-(IBAction)requestMessages{
	NSString* urlStr = [NSString stringWithFormat:@"%@messages/?other_user_id=%@",kBaseURL, self.currentItem[kID] ];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    
	
	MyURLConnection* myconn = [[MyURLConnection alloc] initWithURL:urlStr target:self
												 succeededCallback:@selector(requestSucceeded:myURLConnection:)
													failedCallback:@selector(requestFailed:myURLConnection:)
														   context:[NSNumber numberWithInt:1]];
    [myconn get];
    [self showRightLoading];
	
}

-(IBAction)requestSendMessage:(NSString*)text{

    //[self.view findAndResignFirstResonder];
    /*if (![Utils isTextInputFilled:nameField] || ![Utils isTextInputFilled:passwordField]) {
        [Utils alertMessage:@"Please enter username and password to login."];
        return;
    }*/
	NSString* urlStr = [NSString stringWithFormat:@"%@messages",kBaseURL];
    
    
	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    
	
	MyURLConnection* myconn = [[MyURLConnection alloc] initWithURL:urlStr target:self
												 succeededCallback:@selector(requestSucceeded:myURLConnection:)
													failedCallback:@selector(requestFailed:myURLConnection:)
														   context:[NSNumber numberWithInt:2]];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%@",self.currentItem[kID]],@"receiver_id",
                          text,@"content",
                          [Utils setting:kSessionToken ],@"auth_token",
                          nil];
    
    [myconn post:dict];
    
    [self showRightLoading];
	
}


-(void)requestSucceeded:(NSString*)result myURLConnection:(MyURLConnection*)connection{
    [self hideRightLoading];
	int statuCode = connection.statusCode;
	if(statuCode != 200){
		[self hideLoadingView];
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([dict objectForKey:@"error"]) {
            [Utils alertMessage:[dict objectForKey:@"error"]];
        }
        else{
            [Utils alertMessage:[NSString stringWithFormat:@"Request error:%d\n%@", statuCode,connection.requestURL]];
            
        }
		//[Utils alertMessage:@"A temporary application error has occurred.  This could be a connectivity issue.  Please try again later."];
		//[Utils alertMessage:[[dict objectForKey:@"response"] objectForKey:@"message"]];
		connection = nil;
		return;
	}
	
	
	
	
	[self requestSucceededResultHandler:connection.context result:result];
	
	[self hideLoadingView];
	
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	connection = nil;
	
	
	
}

-(void)requestFailed:(NSError*)error myURLConnection:(MyURLConnection*)connection{
    [self hideRightLoading];

	/*if([error code] == NSURLErrorNotConnectedToInternet){
     [Utils alertMessage:@"This application requires an internet connection to function. Please check your settings."];
     }
     else {
     [Utils alertMessage:[error localizedDescription]];
     
     }*/
	//[Utils alertMessage:[error localizedDescription]];
	[self requestFailedHandlerForError:error forMyURLConnection:connection];
	connection = nil;
	[self hideLoadingView];
	
}

-(void)requestFailedHandlerForError:(NSError*)error forMyURLConnection:(MyURLConnection*)connection{
    [Utils alertMessage:[error localizedDescription]];
}


-(void)requestSucceededResultHandler:(id)context result:(NSString*)result{
    NSLog(@"result:%@",result);
    
    
    
	if ([context intValue] == 1) {
        //test data
        //result = [Utils stringFromFileNamed:@"message.json"];
        NSArray* list = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([list count] > 0) {
             self.messages = [[[list reverseObjectEnumerator] allObjects] mutableCopy];
            //self.messages = [list mutableCopy];
            [self.tableView reloadData ];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewRowAnimationTop animated:NO];
        }
        
	}
    else if ([context intValue] == 2) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        //[Utils alertMessage:dict[@"success"]];
        [self sentToServer];
        
	}
    
    
}

-(BOOL)isOutgoing:(NSDictionary*)dict{
    if ([dict[kSender][kFname] isEqualToString: kYou]) {
        return YES;
    }
    return NO;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //test data
    //self.currentItem[kID] = @240;
    self.delegate = self;
    self.dataSource = self;
    
   // self.title = @"Messages";
    [self setNavTitle:self.currentItem[@"name"]];
    [self addLeftBackButton];
    
   /* self.messages = [[NSMutableArray alloc] initWithObjects:
                     @"Testing some messages here.",
                     @"Options for avatars: none, circles, or squares",
                     @"This is a complete re-write and refactoring.",
                     @"It's easy to implement. Sound effects and images included. Animations are smooth and messages can be of arbitrary size!",
                     nil];
    
    self.timestamps = [[NSMutableArray alloc] initWithObjects:
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate date],
                       nil];*/
    
    float delta = 20;
    delta += 44;
    
    loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 320,  kIphoneHeight-delta)];
    
	loadingLabel.text =  _(@"Loading...");
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.textColor = kGrayTextColor;
	loadingLabel.backgroundColor = kBackgroundColor;
    
	//loadingLabel.alpha = 0;
	loadingLabel.font = [UIFont systemFontOfSize:15];
	loadingLabel.hidden = YES;
	
	
		
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.frame =CGRectMake(320/2-10, loadingLabel.frame.size.height/2-35, 20, 20);
	
	spinner.hidesWhenStopped = YES;
	//[spinner startAnimating];
	spinner.hidden = YES;
	[self.view addSubview:loadingLabel];
    
    [self requestMessages];
    
  }

- (void)buttonPressed:(UIButton*)sender
{
    // Testing pushing/popping messages view
    MessageViewController *vc = [[MessageViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    messageSending = text;
    [self requestSendMessage:text];
}

- (void)sentToServer
{
    NSString* text = messageSending;
    NSDictionary* newItem = @{kSender:@{kFname:kYou},kContent:text};
    if (!self.messages) {
        self.messages = [NSMutableArray arrayWithCapacity:10];
    }
    [self.messages addObject:newItem];
    
    //[self.timestamps addObject:[NSDate date]];
    /*
    if((self.messages.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];*/
    [JSMessageSoundEffect playMessageSentSound];
    [self finishSend];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = self.messages[[indexPath row]];
    return [self isOutgoing:dict]? JSBubbleMessageTypeOutgoing : JSBubbleMessageTypeIncoming;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleSquare;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyIncomingOnly;
}

- (JSAvatarStyle)avatarStyle
{
    return JSAvatarStyleCircle;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* dict = self.messages[[indexPath row]];
    return dict[kContent];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [self getImageFromUrlString:self.currentItem[kImageURL] tag:0];
   // return [UIImage imageNamed:@"demo-avatar-woz"];
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"demo-avatar-jobs"];
}

-(UIImage*)getImageFromUrlString:(NSString*)urlStr tag:(int)tag{
	
	if(!urlStr || [urlStr isEqualToString:@""]  ){
		return nil;
	}
	//NSString* key = [[urlStr componentsSeparatedByString:@"/"] lastObject];
	NSString* key = urlStr;
    
	if ( [imageCacheDict objectForKey:key ]) {
		return  [imageCacheDict objectForKey:key ];
	}
	else {
		/*UIImage* image = [self loadLocalImageForKey:key];
         if (image) {
         return image;
         }
         else {*/
        [self requestThumbImage:urlStr tag:tag];
		//}
        
	}
    
	
	return nil;
}

#pragma mark get thumb image from URL
-(void)requestThumbImage:(NSString*)urlStr tag:(int)tag{
	
	//NSLog(@"===> image request %d: %@", index, urlStr );
	
	MyURLConnection* imageConn = [[MyURLConnection alloc] initWithURL:urlStr target:self
													succeededCallback:@selector(requestThumbImageSucceeded2:myURLConnection:)
													   failedCallback:@selector(requestThumbImageFailed2:myURLConnection:)
															 usesData:YES
															  context:[NSNumber numberWithInt:tag]];
	[imageConn get];
	[self requestThumbLoadingViewHanlder];
	
}

-(void)requestThumbLoadingViewHanlder{
}

-(void)requestThumbImageSucceeded2:(NSData*)result myURLConnection:(MyURLConnection*)connection{
	
	
	
	if(connection.statusCode != 200){
		result = nil;
	}
	int tag = [connection.context intValue];
	
	if(!imageCacheDict){
		self.imageCacheDict = [[NSMutableDictionary alloc] init];
	}
	UIImage* image = nil;
	if(result){
		image = [UIImage imageWithData:result];
	}
	if(image && [image isKindOfClass:[UIImage class]]){
		//NSString* key = [[connection.requestURL componentsSeparatedByString:@"/"] lastObject];
		NSString* key = connection.requestURL;
		[imageCacheDict setObject:image forKey:key ];
		//[self localCacheImage:image forKey:key];
		if (tag > 0) {
			UIImageView* imageView = (UIImageView*)[self.view viewWithTag:tag];
			imageView.image = image;
		}
	}
    [self.tableView reloadData];
	
}


-(void)requestThumbImageFailed2:(NSError*)error myURLConnection:(MyURLConnection*)connection{
	
}




@end
