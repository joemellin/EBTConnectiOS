//
//  Utils.h
//  Taksee
//
//  Created by ross on 2/11/09.
//  Copyright 2009 zxZX. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "Database.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseRequestViewController.h"
#import "UIImageTool.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "WimAdditions.h"
#import "EBTAppDelegate.h"

#import "MyURLConnection.h"

#import "UIView+FirstResponder.h"
#import "constants.h"


#define kIsiPhone5 [Utils isiPhone5]
#define kiPhone5HeightDelta 88
#define kIsIpad [Utils isIpad]
#define kIphoneHeight [Utils iphoneHeight]



@interface Utils : NSObject {
	
	
}
+(float)iphoneHeight;

+(BOOL)isIpad;
+(float)lastFontSize;
+(void)applyiPhone5Y:(float)y forView:(UIView*)view;
+(void)applyiPhone5Height:(float)height forView:(UIView*)view;
+(void)applyiPhone5Frame:(CGRect)frame forView:(UIView*)view;
+(BOOL)isiPhone5;
+(void)applyiPhone5YDelta:(float)yDelta forView:(UIView*)view;
+(void)applyiPhone5HeightChangeforView:(UIView*)view;

+(NSInteger)intDateFromString:(NSString*)dateString;
+(void)saveFavorite;
+(NSString*)appCacheDir;

+(void)showModalSubViewWithName:(NSString*)name withDelegate:(id)delegate;
+(void)showModalSubViewWithNameNoAnimation:(NSString*)name withDelegate:(id)delegate;

+(NSArray*)arrayWithItemsButFirstOneFromArray:(NSArray*)list;
+(NSString*)getCurrentFullDate;
+(EBTAppDelegate*)appDelegate;
+(NSString*)stringFromFileNamed:(NSString*)name;
+(NSString*)formatPrice:(NSString*)digits;
+(NSString*)stringByCancatingList:(NSArray*)_displayList withChar:(NSString*)concat;
+(NSString*)formatString:(NSString*)digits withChar:(NSString*)concat withGroupCount:(int)count withMaxGroup:(int)maxGroup;
+(NSString*)appDocDir;
+(UIViewController*)previousControllersOf:(UIViewController*)controller;
+(UIViewController*)previousControllersOf:(UIViewController*)controller atIndex:(int)index;
+(BOOL)isTextInputFilled:(id)textInput;
+(NSString*)stringForKey:(NSString*)key inQueryString:(NSString*)queryString;
+(NSString*)dictToPlistXML:(NSDictionary*) dict;
+(NSMutableDictionary*)plistXMLToDict:(NSString*)plist;
+(void)showSubViewWithNameNoAnimation:(NSString*)name withDelegate:(id)delegate;
+(void)showSubViewWithName:(NSString*)name withDelegate:(id)delegate;
+(UIColor*)colorFromDict:(NSDictionary*)dict;
+(float)calculateHeightOfMultipleLineText:(NSString*)text withFont:(UIFont*)font withWidth:(float)width;
+(void)alertMessage:(NSString*)msg;
+(void)alertMessage:(NSString*)msg withSecondButtonTitle:(NSString*)title delegate:(id)delegate;
+(void)alertMessage:(NSString*)msg withTitle:(NSString*)title  withSecondButtonTitle:(NSString*)title2 delegate:(id)delegate;
+(NSDateComponents*)getCurrentDateComponent;
+(NSDateComponents*)getDateComponentOfDate:(NSDate*)date;
+(NSString*)getCurrentTimeStamp;
+(NSString*)getCurrentDate;
+(NSString*)getDateStringOfDate:(NSDate*)date;
+(NSString*)toSlashDate:(NSString*)date;
+(NSString*)dateStringFromTimestamp:(NSString*)timestamp;
+(UIColor*)colorWithRed:(float)red green:(float)green blue:(float)blue;
+(NSDate*)dateFromISOString:(NSString*)date;
+(NSDate*)dateFromDateString:(NSString*)date;
+(NSString*)formatDate:(NSString*)date;
+(NSString*)formatDate2:(NSString*)date;
+(id)setting:(NSString*)key;
+(void)setSettingForKey:(NSString*)key withValue:(id)value;
+(void)removeSettingForKey:(NSString*)key;
+(id)setting2:(NSString*)key;
+(void)setSetting2ForKey:(NSString*)key withValue:(id)value;
+(NSArray*)sortArray:(NSArray*)list byKey:(NSString*)key;
+(NSMutableArray*)makeListAndObjectsMutable:(NSArray*)list;
+(UIFont*)boldSystemFontOfSize:(float)size;
+(UIFont*)systemFontOfSize:(float)size;
+(UIFont*)adjustFont:(UIFont*)font;
+(BOOL)dict1:(NSDictionary*)dict1 isSameAsDict2:(NSDictionary*)dict2;
+(void)loadSelectedFormatDict;
+(void)saveSelectedFormat:(NSDictionary*)formatDict forExhibitionName:(NSString*)name;
+(NSArray*)listFromXMLDict:(NSDictionary*)dict withName:(NSString*)name;
+(NSString*)wrapHTML:(NSString*)html;
+(void)saveSettings:(NSDictionary*)argDict;
+(NSString*)hexColorFromRed:(float)r green:(float)g blue:(float)b;
+(NSString*)hexFromDec:(int)dec;
+(void)applyiPhone5HeightDelta:(float)hDelta forView:(UIView*)view;
+(void)applyiPhone5YChangeForView:(UIView*)view;
+(void)applyiPhone4YDelta:(float)yDelta forView:(UIView*)view;
+(void)applyiPhone4Frame:(CGRect)frame forView:(UIView*)view;
+(void)applyYDelta:(float)yDelta forView:(UIView*)view;

+(NSString*)formatString:(NSString*)digits withChar:(NSString*)concat withGroupCount:(int)count withMaxGroup:(int)maxGroup;
@end
