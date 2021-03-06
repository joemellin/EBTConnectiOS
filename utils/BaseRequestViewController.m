//
//  BaseRequestViewController.m
//  Little Things
//
//  Created by Zhaohong Chen on 5/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseRequestViewController.h"
#import "Utils.h"
#import "TabBarViewController.h"
#import "ConnectionsViewController.h"
#import "LoginViewController.h"

@implementation BaseRequestViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Customization
    }
    return self;
}
/*
 Implement loadView if you want to create a view hierarchy programmatically
 - (void)loadView {
 }
 */


- (void)viewDidLoad {	
		
    downloadConn = nil;
    self.preferredContentSize = kScreenBounds.size;

	loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, kScreenBounds.size.width,  kScreenBounds.size.height)];
    
	loadingLabel.text =  _(@"Loading...");
	loadingLabel.textAlignment = NSTextAlignmentCenter;
	loadingLabel.textColor = kGrayTextColor;
	loadingLabel.backgroundColor = kBackgroundColor;

	//loadingLabel.alpha = 0;
	loadingLabel.font = [UIFont systemFontOfSize:15];
	loadingLabel.hidden = YES;
	
	
	noContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, kScreenBounds.size.width,  305)];
	noContentLabel.numberOfLines = 0;
	noContentLabel.text =  kLoadingMessage;
	noContentLabel.textAlignment = NSTextAlignmentCenter;
	noContentLabel.textColor = [UIColor grayColor];
	noContentLabel.backgroundColor= [UIColor clearColor];	
	noContentLabel.alpha = 1.0;
	noContentLabel.font = [UIFont boldSystemFontOfSize:16];
	noContentLabel.hidden = YES;
	
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.frame =CGRectMake(kScreenBounds.size.width/2-10, loadingLabel.frame.size.height/2-35, 20, 20);
	
	spinner.hidesWhenStopped = YES;	
	//[spinner startAnimating];
	spinner.hidden = YES;
	[self.view addSubview:loadingLabel];
	[self.view addSubview:noContentLabel];

	
	
	[self.view addSubview:spinner];			
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
									initWithTitle:@"Back"
									style:UIBarButtonItemStyleBordered
									target:nil
									action:nil];
	self.navigationItem.backBarButtonItem = backButton;
    
	[super viewDidLoad];
    
    self.view.backgroundColor = kBackgroundColor;
    [self addLeftBackButton];
}

-(void)setNavTitle:(NSString*)title{
    self.navigationItem.title = title;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.translucent = NO;
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


-(void)addLogoutButtonToView:(UIView*)view{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenBounds.size.width-57-10, 10, 45, 35);
	[button setBackgroundImage:[UIImage imageNamed:@"logoutButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)logout{
    UIActionSheet* action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles: nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [Utils removeSettingForKey:kSessionToken];
        [Utils removeSettingForKey:kLoginInfoDict];
        [Utils setSettingForKey:kLoggedOut withValue:@"1"];
        [[Utils appDelegate].loginViewController showController];
    }
}

-(void)backToGroup{
    [[Utils appDelegate].connectionsController requestGroup];
    if([[[Utils appDelegate] tabBarViewController] selectedIndex] == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[[Utils appDelegate] tabBarViewController] setSelectedIndex:1];
        [[[[[Utils appDelegate] tabBarViewController] viewControllers] objectAtIndex:1] popToRootViewControllerAnimated:YES];
    }
}

-(void)addGroupBackButton{
    
    self.navigationItem.hidesBackButton = YES;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 10, 0, 0);
	[button setBackgroundImage:[UIImage imageNamed:@"groupback"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToGroup) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
    [self.view addSubview:button];
    
}

-(void) addLeftBackButtonHome {
    self.navigationItem.hidesBackButton = YES;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 0, 0);
    [button setBackgroundImage:[UIImage imageNamed:@"grayHome"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self setViewFrame:button];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)addRightButtonWithImage:(UIImage*) image target:(id)target selector:(SEL) selector {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 45, 35);
	[button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

-(void)addTableDescription:(NSString*)description{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    imageView.image = [UIImage imageNamed:@"describebar"];
    [self setViewFrame:imageView];
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(15 , 0, kScreenBounds.size.width-30, 50)];
    label.numberOfLines = 0;
    label.textColor = kGrayTextColor;
    label.text =  description;
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    //label.textAlignment = UITextAlignmentCenter;
    [imageView addSubview:label];
    myTableView.tableHeaderView = imageView;
    
}



-(void)next{
    
}

-(void)addFullBackground{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    imageView.image = [UIImage imageNamed:@"bg_full.png"];
    [self.view insertSubview:imageView atIndex:0];
}

-(void)addDetailBackground{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 704, 768)];
    imageView.image = [UIImage imageNamed:@"bg.png"];
    [self.view insertSubview:imageView atIndex:0];
}

-(void)addHintBarWithText:(NSString*)text{
    UINavigationBar* toolbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 768-44-20-49, 800, 49)];
    toolbar.barStyle = UIBarStyleBlack;
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, 700, 44)];
    hintBarLabel = label;
    label.numberOfLines = 1;
    label.textColor = [UIColor whiteColor];
    label.text =  text;
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [toolbar addSubview:label];
    //[label release]; 
    [self.view addSubview:toolbar];
}

-(void)backToSplitViews{
    [self dismissModalViewControllerAnimated:YES];
}



-(void)hideMaster
{
   // [Utils appDelegate].splitVC.modalPresentationStyle = UIModalPresentationFullScreen;
   // [[Utils appDelegate].splitVC presentModalViewController:[[[Utils appDelegate].splitVC viewControllers] objectAtIndex:1] animated:NO];
    
}




/*-(void)checkNetwork{
	Reachability* reachability = [Reachability reachabilityForInternetConnection];
	
	NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
	
    hasWiFi = NO;
	if(remoteHostStatus == NotReachable) { 
		
	}
	else{ 
		
		if(remoteHostStatus == ReachableViaWiFi) { 
			hasWiFi = YES;
		}
		else if(remoteHostStatus == ReachableViaWWAN) { 
		}
	}
	
}*/




-(void)addDoneButton{
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(done)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)done{
   if (downloadConn) {
        NSLog(@"downloadConn cancel");
        [downloadConn cancel];
        downloadConn = nil;

        
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setupBgView{
    bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, kScreenBounds.size.height)];
    bgView.image = [UIImage imageNamed:@"bg_without_logo.png"];
    [self.view insertSubview:bgView atIndex:0];
}


-(void)showVideoLoadingView{
    [self.view bringSubviewToFront:videoLoadingView];
    videoLoadingView.hidden = NO;
    videoLoadingLabel.text = [NSString stringWithFormat:@"Downloading resource %d/%d", videoIndex + 1, [self.videoList count]];
}

-(void)hideVideoLoadingView{
    videoLoadingView.hidden = YES;
}




-(void)setupVideoLoadingView{
    float height = 200;
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(300, 280, 424, height)];
    videoLoadingView = contentView;
    videoLoadingView.hidden = YES;
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 424, height)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.alpha = 0.9;
    imageView.layer.cornerRadius = 10;
    [contentView addSubview:imageView];
    
   /* UIActivityIndicatorView* spinner1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	spinner1.frame =CGRectMake(130, 130, 20, 20);	
	spinner1.hidesWhenStopped = YES;	
	[spinner1 startAnimating];
	[contentView addSubview:spinner1];
    [spinner1 release];*/
    videoProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    videoProgressView.frame = CGRectMake(40, 110, 344, 20);
    videoProgressView.progress = 0;
    [contentView addSubview:videoProgressView];
    
    UILabel* label;
	label = [[UILabel alloc] initWithFrame:CGRectMake(40 , 60, 344, 40)];
	label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.backgroundColor= [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:17];
	[contentView addSubview:label];
	videoLoadingLabel = label;
    
    
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"btn_cancel_iPhone.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(cancelDownload) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(68, 115, 103, 31);
    [contentView addSubview:button];
    videoCancelButton = button;    
    videoCancelButton.hidden = YES;

    [self.view addSubview:contentView];
}

-(void)cancelDownload{
    [self hideVideoLoadingView];
    videoProgressView.progress = 0;
    [downloadConn cancel];
    downloadConn = nil;
}

-(void)pickSceneOrGoHome{
    
}

-(void)requestVideoFailed:(NSError*)error myURLConnection:(MyURLConnection*)connection{
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskID];

	[self requestVideoFailedHandler:error myURLConnection:connection];
	connection = nil;
    downloadConn = nil;
}

-(void)requestVideoFailedHandler:(NSError*)error myURLConnection:(MyURLConnection*)connection{
    [self hideVideoLoadingView];
    //[Utils alertMessage:[error description]];
    [Utils alertMessage:@"Your download has been interrupted possibly due to a connection error, would you like to retry?"];
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

-(void)addTopLeftLogo{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo_FaceToFace.png"]];
    imageView.frame = CGRectMake(55, 20, 250, 59);
	[self.view addSubview:imageView];
}
-(void)addBackgroundImage{
	UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background2.png"]];
	[self.view insertSubview:imageView atIndex:0];
}

-(void)addBackgroundImage2{
	//UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background design3b.jpg"]];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];

	[self.view insertSubview:imageView atIndex:0];
}



-(void)showLoadingView{
	//[self.view bringSubviewToFront:bgView];
	//[self.view bringSubviewToFront:spinnerView];
	[self.view bringSubviewToFront:loadingLabel];
	[self.view bringSubviewToFront:spinner];
	loadingLabel.hidden =NO;
	//spinner.hidden =NO;	
	spinnerView.hidden = NO;
	[spinner startAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)hideLoadingView{
	loadingLabel.hidden =YES;
	
	[spinner stopAnimating];
	spinnerView.hidden = YES;
	//spinner.hidden =YES;	
	[self.view sendSubviewToBack:bgView];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}









-(void)back{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)showNoContent{
	noContentLabel.hidden = NO;
}

-(void)hideNoContent{
	noContentLabel.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
	shouldStopLoadingImage = YES;
}
-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	shouldStopLoadingImage = NO;
	
}


-(void)delete{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to delete it?"
												   delegate:self cancelButtonTitle:@"NO"
										  otherButtonTitles:@"YES",nil];
	[alert show];
}





-(UIImage*)getImageFromUrlString:(NSString*)urlStr tag:(int)tag{
	
	if(!urlStr || [urlStr isEqualToString:@""]  ){			
		return nil;
	}	
	//NSString* key = [[urlStr componentsSeparatedByString:@"/"] lastObject];
	NSString* key = urlStr;

	if ( [self.imageCacheDict objectForKey:key ]) {
		return  [self.imageCacheDict objectForKey:key ];
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
	[imageConn getWithoutToken];
	[self requestThumbLoadingViewHanlder];
	
}

-(void)requestThumbLoadingViewHanlder{
}

-(void)requestThumbImageSucceeded2:(NSData*)result myURLConnection:(MyURLConnection*)connection{	
	
	
	
	if(connection.statusCode != 200){
		result = nil;
	}	
	int tag = [connection.context intValue];
	
	if(!self.imageCacheDict){
		self.imageCacheDict = [[NSMutableDictionary alloc] init];
	}
	UIImage* image = nil;
	if(result){
		image = [UIImage imageWithData:result];	
	}
	if(image && [image isKindOfClass:[UIImage class]]){		
		//NSString* key = [[connection.requestURL componentsSeparatedByString:@"/"] lastObject];
		NSString* key = connection.requestURL;
		[self.imageCacheDict setObject:image forKey:key ];
		//[self localCacheImage:image forKey:key];
		if (tag > 0) {
			UIImageView* imageView = (UIImageView*)[self.view viewWithTag:tag];
			imageView.image = image;
		}		
	}			
	[self hideLoadingView];
	
}

-(void)localCacheImage:(UIImage*)image forKey:(NSString*)key{
	[self saveLocalImage:image forKey:key];
	
}

-(void)requestThumbImageFailed2:(NSError*)error myURLConnection:(MyURLConnection*)connection{
	
}

-(void)requestSucceededResultHandler:(id)context result:(NSString*)result{
}

-(void)requestSucceededErrorHandler:(id)context result:(NSString*)result statusCode:(int)code{
}

-(void)requestSucceeded:(NSString*)result myURLConnection:(MyURLConnection*)connection{

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
        
        [self serverErrorHandler];
		//[Utils alertMessage:@"A temporary application error has occurred.  This could be a connectivity issue.  Please try again later."];
		//[Utils alertMessage:[[dict objectForKey:@"response"] objectForKey:@"message"]];
		connection = nil;
		return;
	}			
	
	
	
	[self loadingViewHanlder:connection.context];
	
	[self requestSucceededResultHandler:connection.context result:result];
	
	
	
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	connection = nil;
	
	
	
}

-(void)serverErrorHandler{
    
}

-(void)connectionErrorHandler{
    
}


-(void)applyYDelta:(float)delta ForSubviewsOfView:(UIView*)view{
    for(UIView* subview in view.subviews){
        if ([subview isEqual:loadingLabel] || [subview isEqual:spinner]) {
            continue;
        }
        [Utils applyYDelta:delta forView:subview];
    }
    
}

-(void)applyIphone4YDeltaForSubviewsOfView:(UIView*)view{
    if (!kIsiPhone5) {
        [self applyYDelta:-kiPhone5HeightDelta/2 ForSubviewsOfView:view];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (needsNavBar) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];


    }
}

-(void)loadingViewHanlder:(int)context{
	[self hideLoadingView];
}

-(void)addTitleImage:(NSString*)name{
	UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
	[self setViewFrame:imageView];
	self.navigationItem.titleView = imageView;
	
}

-(void)addCancelButton{
	
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"btn_cancel_iphone4.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
	UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = item;
	
	
}

-(void)addBackButton{
	
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"btn_back_iPhone4.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
	UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = item;
	
	
}

-(void)cancel{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)requestFailed:(NSError*)error myURLConnection:(MyURLConnection*)connection{
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
    [self  connectionErrorHandler];

}

-(NSMutableArray*)mutableArrayFromArray:(NSArray*)list{
	NSMutableArray* l = [NSMutableArray array];
	for(NSDictionary* item in list){
		NSMutableDictionary* d = [item mutableCopy];
		[l addObject:d];			
	}
	return l;
}

-(float)formatDistance:(float)rawValue{
	float v = rawValue;
	float displayValue;
	if (v >= 1) {
		displayValue = (int)v;
		if (v - displayValue >= 0.5) {
			displayValue += 0.5;
		}
	}
	else {
		displayValue = 0.5;
	}
	return displayValue;
	
}

-(NSString*)formatDistanceText:(float)displayValue{
	NSString* text;
	if (displayValue >= 1) {
		text = [NSString stringWithFormat:@"%.1f km",displayValue];
	}
	else {
		text = @"500 m";
	}
	return text;
}

-(int)formatTime:(float)rawValue{
	int v = (int)rawValue;
	int displayValue;
	int delta = v / 10;
	displayValue = delta * 10;
	
	return displayValue;
	
}

-(NSString*)formatTimeText:(int)displayValue{
	NSString* text;
	int hour = displayValue / 60;
	int min = displayValue % 60;
	NSString* minText = @"min";
	NSString* hourText = @"hour";
	if (min > 1) {
		minText = @"mins";
	}
	if (hour > 1) {
		hourText = @"hours";
	}
	if (hour == 0) {
		text = [NSString stringWithFormat:@"%d %@",min,minText];
	}
	else if (min == 0) {
		text = [NSString stringWithFormat:@"%d %@",hour, hourText];
	}
	else  {
		text = [NSString stringWithFormat:@"%d %@ %d %@",hour,hourText,min,minText];
	}
	
	return text;
}


-(void)addSelectedBackgroundForCell:(UITableViewCell*)cell{
    UIImageView* cellbgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, 44)];
    cellbgView.image = [UIImage imageNamed:@"bg_item_ipad@2x.png"];
    cell.selectedBackgroundView = cellbgView;
}

-(void)setProgress:(float)progress{
    //NSLog(@"progress: %f",progress);
    [videoProgressView setProgress:progress animated:YES];
}


-(void)addTopLogo{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(284, 46, 200, 55)];
    if (!kIsIpad) {
        imageView.frame = CGRectMake(60, 5, 200, 55);
    }
    imageView.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:imageView];
}

-(void)applyIphone5YForSubviewsWithView:(UIView*)containerView{
    if (!kIsiPhone5) { 
        return;
    }
    [Utils applyiPhone5HeightChangeforView:containerView];
    for(UIView* view in containerView.subviews){
       
        [Utils applyiPhone5YDelta:30 forView:view];
    }
}

-(void)addSettingsButton{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"cog.png"]  forState:UIControlStateNormal];
	[button addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(720, 950, 40, 40);
    if (!kIsIpad) {
        button.frame = CGRectMake(280, 415, 30, 30);

    }
    
    [self.view addSubview:button];
    settingButton = button;
    

}

-(void)dismissSettings{
    [self.popoverSettingController dismissPopoverAnimated:YES];
    
}

-(void)setupNoInternetUIWithMessage:(NSString*)message{
    noInternetView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 768, 1000)];
    if (!kIsIpad) {
        noInternetView.frame = CGRectMake(0, 60, kScreenBounds.size.width, 460);
    }
    noInternetView.backgroundColor = self.view.backgroundColor;
    
    UILabel* label;
	label = [[UILabel alloc] initWithFrame:CGRectMake(184 , 40, 400, 180)];
   
	label.numberOfLines = 0;
    //label.textAlignment = UITextAlignmentCenter;
	//label.textColor = [UIColor whiteColor];
    label.text = message;
	label.backgroundColor= [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:25];
    if (!kIsIpad) {
        label.frame = CGRectMake(40, 30, 240, 180);
        label.font = [UIFont systemFontOfSize:20];

    }

	[noInternetView addSubview:label];
    
    float lastY;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Check for Internet Connection" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(checkInternet) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(184, 300, 400, 44);
    if (!kIsIpad) {
        button.frame = CGRectMake(40, 250, 240, 44);
        
    }

    lastY = button.frame.origin.y + button.frame.size.height;
    
    [noInternetView addSubview:button];
    
    
    [self.view addSubview:noInternetView];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


































	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


@end
