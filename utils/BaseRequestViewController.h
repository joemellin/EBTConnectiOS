//
//  BaseRequestViewController.h
//  Little Things
//
//  Created by Zhaohong Chen on 5/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Shorthand for getting localized strings, used in formats below for readability
#define _(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
#define kLoadingMessage  _(@"Loading...")
#define kErrorMessage   _(@"Error while loading")
#import "MyURLConnection.h"

#import <MediaPlayer/MediaPlayer.h>

@class CLLocation;
@class CLHeading;
@class MyURLConnection;

@protocol SplitDetailViewProtocol <NSObject>

-(void)updateWithItem:(NSDictionary*)item;
-(void)updateWithCategory:(NSDictionary*)item;
-(void)updateWithString:(NSString*)item;
@end

@interface BaseRequestViewController : UIViewController {
	UITableView* myTableView;
	UIActivityIndicatorView*  spinner;
	UIView* spinnerView;
	UILabel* loadingLabel;	
	UILabel* loadingLabel2;
	UILabel* noContentLabel;
	UIActivityIndicatorView* spinner2;
	
	bool shouldStopLoadingImage;
	bool isModeEdit;
	
	UIBarButtonItem* dismissItem;
	UIBarButtonItem *saveItem;
	UIBarButtonItem *editItem;
	
	bool showCancelChangesButton;
	
	UILabel* placeHintLabel;
	CGRect originalLoadingRect;
	int testCount;
	
	UIImageView* bgView;
	UIButton* infoButton;
	UIToolbar* bottomBar;
    
    UIImageView* playerImageView;
    
    int videoIndex;
    
    UIView* videoLoadingView;
    UILabel* videoLoadingLabel;
    UIProgressView* videoProgressView;
    MyURLConnection* downloadConn;
    BOOL hasWiFi;
    
    UIButton* videoCancelButton;
    UILabel* hintBarLabel;
    UIView* noInternetView;
    
    UIButton* settingButton;
    BOOL needsNavBar;
}
@property(nonatomic,strong) UIPopoverController* popoverSettingController;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskID;

@property(nonatomic,strong) UIWebView* webView;
@property(nonatomic,strong) NSMutableArray* videoList;
-(void)setViewFrame:(UIView*)view;
-(void)setNavTitle:(NSString*)title;
-(NSArray*)getAllWordList;
-(void)addSelectedBackgroundForCell:(UITableViewCell*)cell;
-(void)addHintBarWithText:(NSString*)text;
-(void)addTopLeftLogo;
-(void)addLeftBackButton;
-(void)addFullBackground;
-(void)addRightSettingButton;
-(void)addDetailBackground;
-(UIViewController<SplitDetailViewProtocol>*)getSplitDetailViewControllerFromClassName:(NSString*)name;
-(void)addPlayerViewForVideoAtPath:(NSString*)path withFrame:(CGRect)frame;
-(void)playPortraitVideo:(NSString*)path;
-(void)requestVideoFromIndex:(int)index;
-(void)play:(NSString*)code;
-(void)showVideoLoadingView;
-(NSArray*)getWordList;
-(void)hideVideoLoadingView;
-(float)formatDistance:(float)rawValue;
-(NSString*)formatDistanceText:(float)displayValue;
-(int)formatTime:(float)rawValue;
-(NSString*)formatTimeText:(int)displayValue;
-(void)setProgress:(float)progress;
-(void)addInfoButton;
-(void)showInfo;
-(void)showLoadingView;
-(void)hideLoadingView;
-(void)showLoadingView2;
-(void)back;
-(void)showNoContent;
-(void)hideNoContent;
-(void)backToSplitViews;
-(void)addRightArrowButton;
-(void)addGroupBackButton;
-(void)addLogoutButtonToView:(UIView*)view;
-(UIImage*)getImageFromUrlString:(NSString*)urlStr tag:(int)tag;
-(void)requestThumbImage:(NSString*)urlStr tag:(int)tag;
-(void)requestThumbLoadingViewHanlder;
-(void)localCacheImage:(UIImage*)image forKey:(NSString*)key;
-(void)loadingViewHanlder:(int)context;
-(NSMutableArray*)mutableArrayFromArray:(NSArray*)list;
-(NSString*)soundFileNameFromDescription:(NSString*)desc;
-(NSString*)formatDatetime:(NSString*)timestamp;
-(UIImage*)loadLocalImageForKey:(NSString*)imageURL;
-(void)saveLocalImage:(UIImage*)image forKey:(NSString*)imageURL;
-(void)addTopLogo;
-(void)addBottomCopyrightAndLicence;
-(void)applyIphone5YForSubviewsWithView:(UIView*)containerView;
-(void)addTableDescription:(NSString*)description;
-(void)backToGroup;

@property(nonatomic,strong) NSMutableArray* displayList;
@property(nonatomic,strong) NSDictionary* selectedItem;
@property(nonatomic,strong) NSMutableDictionary* currentItem;
@property(nonatomic,strong) NSMutableDictionary* imageCacheDict;
@property(nonatomic,strong) NSMutableDictionary* argDict;
@property bool shouldRefresh;
@property bool isBookmarkMode;
@property bool isModeView;
@property(nonatomic,strong) NSMutableArray* displayLetters;
@property bool isEmailCSVMode;
@property(nonatomic,strong) NSMutableArray* storeKeyList;
@property(nonatomic,strong) NSMutableArray* mySegmentList;
-(void)applyYDelta:(float)delta ForSubviewsOfView:(UIView*)view;
-(void)applyIphone4YDeltaForSubviewsOfView:(UIView*)view;

@end


