//
//  Utils.m
//  Taksee
//
//  Created by ross on 2/11/09.
//  Copyright 2009 zxZX. All rights reserved.
//

#import "Utils.h"


@implementation Utils

/* static utility methods */
+(EBTAppDelegate*)appDelegate{
	return (EBTAppDelegate*)[[UIApplication sharedApplication]delegate];
}

+(void)flog:(NSString*)msg{
    NSString* path = [[Utils appDocDir] stringByAppendingPathComponent:@"log.txt"];
   
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (!content) {
        content = @"";
    }
    content = [NSString stringWithFormat:@"%@\n%@",content,msg];
    [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

+(NSString*)stringFromFileNamed:(NSString*)name{
	NSString* result = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil] encoding:NSUTF8StringEncoding error:nil];
	return result;
}

+(NSString*)formatPrice:(NSString*)digits{
	if ([digits isEqualToString:@"Any"]) {
		return digits;
	}
	return [NSString stringWithFormat:@"$%@", digits];
	/*
	//digits = [digits stringByReplacingOccurrencesOfString:@"-" withString:@""];
	return [Utils formatString:digits withChar:@"," withGroupCount:3 withMaxGroup:0];*/
}




+(NSString*)stringByCancatingList:(NSArray*)_displayList withChar:(NSString*)concat{
	// todo: won't this leak?
	NSString* ret = @"";
	for(NSString* item in _displayList){
		ret = [ret stringByAppendingFormat:@"%@%@", item,concat];
	}
	if([ret length] > 0)
		ret = [ret substringToIndex:[ret length] -1];
	return ret;
}

+(NSString*)formatString:(NSString*)digits withChar:(NSString*)concat withGroupCount:(int)count withMaxGroup:(int)maxGroup{
	NSMutableArray* groups = [[NSMutableArray alloc] init];
	while (1) {
		if(([digits length] <= count) || (maxGroup != 0 && maxGroup == [groups count])){
			
			[groups insertObject:digits atIndex:0];	
			break;
		}		
		else {
			NSString* group = [digits substringFromIndex:[digits length] - count];
			digits = [digits substringToIndex:[digits length] - count];
			[groups insertObject:group atIndex:0];			
		}
		
	}
	NSString* formatted = [self stringByCancatingList:groups withChar:concat];
	if([[formatted substringFromIndex:[formatted length] -1] isEqualToString:concat])
		formatted = [formatted substringToIndex:[formatted length] -1];
	return formatted;
}


+(NSString*)appDocDir{
	//get app doc dir
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString* docDir = [paths objectAtIndex:0];
	return docDir;
}

+(NSString*)appCacheDir{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesPath = [paths objectAtIndex:0];	
	return cachesPath;
}

+(UIViewController*)previousControllersOf:(UIViewController*)controller{
	UIViewController* vc = [controller.navigationController.viewControllers objectAtIndex:
							[controller.navigationController.viewControllers count] - 2];
	return vc;
}

+(UIViewController*)previousControllersOf:(UIViewController*)controller atIndex:(int)index{ 
	UIViewController* vc = [controller.navigationController.viewControllers objectAtIndex:
							[controller.navigationController.viewControllers count] - index];
	return vc;
}

+(BOOL)isTextInputFilled:(id)textInput{
	//[textInput setText: [[textInput text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
	NSString* tmp = [[textInput text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if(!tmp || [ tmp isEqualToString:@""]){		
		return NO;
	}
	return YES;
}

+(NSString*)stringForKey:(NSString*)key inQueryString:(NSString*)queryString{	
	NSArray* arguments = [queryString componentsSeparatedByString:@"&"];
	for(NSString* argument in arguments){
		NSArray* tmp = [argument componentsSeparatedByString:@"="];
		if([tmp count] < 2)
			continue;
		NSString* key1 = [[tmp objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString* value1 = [[tmp objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		if([key1 isEqualToString:key])
			return value1;
	}
	return nil;	
}


+(NSString*)dictToPlistXML:(NSDictionary*) dict{
	if (!dict || [[dict allKeys] count] == 0) {
		return @"";
	}
	NSString* path = [[Utils appDocDir] stringByAppendingPathComponent:@"tmpforplist"];
	[dict writeToFile:path atomically:YES];
	NSString* plist = [NSString stringWithContentsOfFile:path
												encoding:NSUTF8StringEncoding error:nil];
	return plist;
}

+(NSMutableDictionary*)plistXMLToDict:(NSString*)plist{
	
	if(!plist || [plist isEqualToString:@""])
		return nil;
	NSMutableDictionary* dict = [(NSDictionary*)[plist propertyList] mutableCopy];
	return dict;
}

+(void)showSubViewWithNameNoAnimation:(NSString*)name withDelegate:(id)delegate {
	Class klass = NSClassFromString(name);
	id vc = [[klass alloc] init];
	[[delegate navigationController] pushViewController:vc animated:NO];
}


+(void)showSubViewWithName:(NSString*)name withDelegate:(id)delegate{
	Class klass = NSClassFromString(name);
	id vc = [[klass alloc] init];
    if([name isEqualToString:@"TabBarViewController"]) {
        [[Utils appDelegate] setTabBarViewController:vc];
    }
	[[delegate navigationController] pushViewController:vc animated:YES];
}

+(void)showModalSubViewWithName:(NSString*)name withDelegate:(id)delegate{
	Class klass = NSClassFromString(name);
	id vc = [[klass alloc] init];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBar.barStyle = UIBarStyleBlack;
    [delegate presentModalViewController:nvc animated:YES];
}

+(void)showModalSubViewWithNameNoAnimation:(NSString*)name withDelegate:(id)delegate{
	Class klass = NSClassFromString(name);
	id vc = [[klass alloc] init];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBar.barStyle = UIBarStyleBlack;
    [delegate presentModalViewController:nvc animated:NO];
}

+(UIColor*)colorFromDict:(NSDictionary*)dict{
	UIColor* color = [UIColor colorWithRed:[[dict objectForKey:@"Red"] floatValue]/255.0
									 green:[[dict objectForKey:@"Green"] floatValue]/255.0
									  blue:[[dict objectForKey:@"Blue"] floatValue]/255.0
									 alpha:1];
	return color;
}

+(void)alertMessage:(NSString*)msg{
	if([msg isEqualToString:@"no internet connection"]){
		msg = @"No Internet Connection";
	}
	
	if([msg isEqualToString:@"timed out"]){
		msg = @"Network request timed out";
	}
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:msg
												   delegate:nil cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

+(void)alertMessage:(NSString*)msg withSecondButtonTitle:(NSString*)title delegate:(id)delegate{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:msg
												   delegate:delegate cancelButtonTitle:@"Cancel"
										  otherButtonTitles:title,nil];
	[alert show];
}

+(void)alertMessage:(NSString*)msg withTitle:(NSString*)title  withSecondButtonTitle:(NSString*)title2 delegate:(id)delegate{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg
												   delegate:delegate cancelButtonTitle:@"Cancel"
										  otherButtonTitles:title2,nil];
	[alert show];
}



+(NSDateComponents*)getCurrentDateComponent{
	//get current time	
	NSCalendar* calendar = [NSCalendar currentCalendar];	
	
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit| NSHourCalendarUnit
	|NSMinuteCalendarUnit|NSSecondCalendarUnit;
	NSDate *date = [NSDate date];
	NSDateComponents *comps2 = [calendar components:unitFlags fromDate:date];
	return comps2;
}

+(NSDateComponents*)getDateComponentOfDate:(NSDate*)date{
	//get current time	
	NSCalendar* calendar = [NSCalendar currentCalendar];	
	
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit| NSHourCalendarUnit
	|NSMinuteCalendarUnit|NSSecondCalendarUnit;	
	NSDateComponents *comps2 = [calendar components:unitFlags fromDate:date];
	return comps2;
}

+(NSString*)getCurrentTimeStamp{
	NSDateComponents* comps2 = [Utils getCurrentDateComponent];
	
	NSString* timestamp = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d",[comps2 year],[comps2 month],[comps2 day],
						   [comps2 hour], [comps2 minute], [comps2 second]  ];
	return timestamp;
}

+(NSString*)getCurrentDate{
	NSDateComponents* comps2 = [Utils getCurrentDateComponent];
	
	NSString* timestamp = [NSString stringWithFormat:@"%02d-%02d",[comps2 month],[comps2 day]
						   ];
	return timestamp;
}

+(NSString*)getCurrentFullDate{
	NSDateComponents* comps2 = [Utils getCurrentDateComponent];
	
	NSString* timestamp = [NSString stringWithFormat:@"%04d%02d%02d",[comps2 year],[comps2 month],[comps2 day]
						   ];
	return timestamp;
}

+(void) handleError:(NSError*)error{
	
}



+(NSArray*)arrayWithItemsButFirstOneFromArray:(NSArray*)list{
    NSRange r = {1, [list count] -1};
    return  [list subarrayWithRange:r];
}




+(NSInteger)intDateFromString:(NSString*)dateString{
    int dateInt = [[dateString stringByReplacingOccurrencesOfString:@"-" withString:@""] intValue];
    return dateInt;
    
}




+(NSArray*)listFromXMLDict:(NSDictionary*)dict withName:(NSString*)name{
    NSString* names = [name stringByAppendingString:@"s"];
    if ([name isEqualToString:@"category"]) {
        names = @"categories";
    }
    NSArray* list = [[dict objectForKey:names] objectForKey:name];
    if (![list isKindOfClass:[NSArray class]] && list) {
        NSArray* list2 = [NSArray arrayWithObject:list];
        return list2;
    }
    return list;
}


+(NSString*)getCurrentDate2{
	/*NSDateComponents* comps2 = [Utils getCurrentDateComponent];
	
	NSString* timestamp = [NSString stringWithFormat:@"%02d/%02d/%04d",[comps2 month],[comps2 day],[comps2 year]
						   ];
	return timestamp;*/
	
	NSDate *gmtTime = [NSDate date];
	NSTimeZone *timeZoneEST = [NSTimeZone timeZoneWithName:@"CST"];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy"];
	[dateFormatter setTimeZone: timeZoneEST];
	NSString *timeStr = [dateFormatter stringFromDate: gmtTime];
	return timeStr;
}

+(NSString*)getDateStringOfDate:(NSDate*)date{
	if (!date) {
		return nil;
	}
	NSDateComponents* comps2 = [Utils getDateComponentOfDate:date];	
	NSString* timestamp = [NSString stringWithFormat:@"%04d%02d%02d",[comps2 year],[comps2 month],[comps2 day]						   ];
	return timestamp;
}





+(NSString*)toSlashDate:(NSString*)date{
	NSArray* parts = [date componentsSeparatedByString:@"-"];
	if([parts count] < 3)
		return date;
	return [NSString stringWithFormat:@"%@/%@/%@", [parts objectAtIndex:1], 
			[parts objectAtIndex:2], [parts objectAtIndex:0]];
}

+(NSString*)dateStringFromTimestamp:(NSString*)timestamp{	
	NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	NSDate *date =[NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
	NSLog(@"formattedDateString for locale %@: %@",
		  [[dateFormatter locale] localeIdentifier], formattedDateString);
	// Output: formattedDateString for locale en_US: Jan 2, 2001
	return formattedDateString;
}
+(UIColor*)colorWithRed:(float)red green:(float)green blue:(float)blue{
	UIColor* color = [UIColor colorWithRed:red/255.0
									 green:green/255.0
									  blue:blue/255.0
									 alpha:1];
	return color;
}
+(NSDate*)dateFromISOString:(NSString*)date{	
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
	NSDate *newsDate = [inputFormatter dateFromString:date ];
	return newsDate;
}

+(NSDate*)dateFromDateString:(NSString*)date{	
	if ([date intValue] == 0) {
		return nil;
	}
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyyMMdd"];
	NSDate *newsDate = [inputFormatter dateFromString:date ];
	return newsDate;
}

+(NSDate*)dateFromDateTimeString:(NSString*)date{	
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
	NSDate *newsDate = [inputFormatter dateFromString:date ];
	return newsDate;
}

+(NSString*)formatDate:(NSString*)date{	
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
	NSDate *newsDate = [inputFormatter dateFromString:date ]; 
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	//[outputFormatter setDateStyle:NSDateFormatterLongStyle];
	//[outputFormatter setTimeStyle:NSDateFormatterLongStyle];
	[outputFormatter setDateFormat:@"HH:mm:ss a MMM d, yyyy"];
	NSString *newDateString = [outputFormatter stringFromDate:newsDate];
	
	return newDateString;
	
}

+(NSString*)formatDate2:(NSString*)date{	
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyyMMdd"];
	NSDate *newsDate = [inputFormatter dateFromString:date ]; 
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	//[outputFormatter setDateStyle:NSDateFormatterLongStyle];
	//[outputFormatter setTimeStyle:NSDateFormatterLongStyle];
	[outputFormatter setDateFormat:@"MMM d, yyyy"];
	NSString *newDateString = [outputFormatter stringFromDate:newsDate];
	
	return newDateString;
	
}

+(NSString*)formatDate3:(NSString*)date{	
	date = [date lowercaseString];
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"dd/MM/yyyy h:m:s a"];
	NSDate *newsDate = [inputFormatter dateFromString:date ]; 
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	//[outputFormatter setDateStyle:NSDateFormatterLongStyle];
	//[outputFormatter setTimeStyle:NSDateFormatterLongStyle];
	[outputFormatter setDateFormat:@"h:mma"];
	NSString *newDateString = [outputFormatter stringFromDate:newsDate];
	newDateString = [newDateString lowercaseString];
	return newDateString;
	
}



+(id)setting:(NSString*)key{
	NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
	return [d objectForKey:key];
}

+(void)setSettingForKey:(NSString*)key withValue:(id)value{
	NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
	[d setObject:value forKey:key];
	[d synchronize];
	
	
}

+(void)removeSettingForKey:(NSString*)key{
	NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
	[d removeObjectForKey:key];
	[d synchronize];
	
	
}

+(id)setting2:(NSString*)key{
	NSData* data = [Utils setting:key];	
	return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+(void)setSetting2ForKey:(NSString*)key withValue:(id)value{
	
	NSData* data =  [NSKeyedArchiver archivedDataWithRootObject:value];		
	[Utils setSettingForKey:key withValue:data];	
	
}

+(NSArray*)sortArray:(NSArray*)list byKey:(NSString*)key{
	NSSortDescriptor* dec = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
	NSArray* sorted = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:dec]];
	return sorted;
}

+(NSMutableArray*)makeListAndObjectsMutable:(NSArray*)list{
	NSMutableArray* results = [NSMutableArray array];
	for(NSDictionary* item in list){
		[results addObject:[item mutableCopy]];
	}
	return results;
}

+(NSString*)queryStringFromDict:(NSDictionary*)dict{
	NSMutableArray* lst = [NSMutableArray array];
	for(NSString* key in dict){
		NSString* item = [NSString stringWithFormat:@"%@=%@",key, [dict objectForKey:key]];
		[lst addObject:item];
	}
	NSString* result = [lst componentsJoinedByString:@"&"];
	return result;
}

+(void)showURL:(NSString*)url{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+(BOOL)dict1:(NSDictionary*)dict1 isSameAsDict2:(NSDictionary*)dict2{
	for(NSString* key in [dict1 allKeys]){
		if (![dict1 isKindOfClass:[NSString class]] || ![dict2 isKindOfClass:[NSString class]]) {
			continue;
		}
		if (![[dict1 objectForKey:key] isEqualToString:[dict2 objectForKey:key]] ) {
			return NO;
		}
	}
	return YES;
}


+(NSString*)hexColorFromRed:(float)r green:(float)g blue:(float)b{
	NSString* hr = [Utils hexFromDec:(int)r];
	NSString* hg = [Utils hexFromDec:(int)g];
	NSString* hb = [Utils hexFromDec:(int)b];
	NSString* hex = [NSString stringWithFormat:@"#%@%@%@", hr,hg,hb];
	return hex;
}

+(NSString*)hexFromDec:(int)dec{
	NSString* hex = [NSString stringWithFormat:@"%02x",dec];
	return hex;
}

+(BOOL)isiPhone5{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        return YES;
    } else {
        return NO;
    }
}

+(void)applyiPhone5Frame:(CGRect)frame forView:(UIView*)view{
    if (![Utils isiPhone5]) {
        return;
    }
    view.frame = frame;
    
}

+(void)applyiPhone4Frame:(CGRect)frame forView:(UIView*)view{
    if ([Utils isiPhone5]) {
        return;
    }
    view.frame = frame;
    
}


+(void)applyiPhone5Height:(float)height forView:(UIView*)view{
    CGRect f0 = view.frame;
    CGRect f = CGRectMake(f0.origin.x, f0.origin.y, f0.size.width, height);
    [Utils applyiPhone5Frame:f forView:view];
}

+(void)applyiPhone5HeightChangeforView:(UIView*)view{
    CGRect f0 = view.frame;
    CGRect f = CGRectMake(f0.origin.x, f0.origin.y, f0.size.width, f0.size.height+kiPhone5HeightDelta);
    [Utils applyiPhone5Frame:f forView:view];
}

+(void)applyiPhone5Y:(float)y forView:(UIView*)view{
    CGRect f0 = view.frame;
    CGRect f = CGRectMake(f0.origin.x, y, f0.size.width, f0.size.height);
    [Utils applyiPhone5Frame:f forView:view];
}

+(void)applyiPhone5YDelta:(float)yDelta forView:(UIView*)view{
    CGRect f0 = view.frame;
    CGRect f = CGRectMake(f0.origin.x, f0.origin.y+yDelta, f0.size.width, f0.size.height);
    [Utils applyiPhone5Frame:f forView:view];
}

+(void)applyYDelta:(float)yDelta forView:(UIView*)view{
    CGRect f0 = view.frame;
    CGRect f = CGRectMake(f0.origin.x, f0.origin.y+yDelta, f0.size.width, f0.size.height);
    view.frame = f;

}

+(void)applyiPhone4YDelta:(float)yDelta forView:(UIView*)view{
    CGRect f0 = view.frame;
    CGRect f = CGRectMake(f0.origin.x, f0.origin.y+yDelta, f0.size.width, f0.size.height);
    [Utils applyiPhone4Frame:f forView:view];
}


+(void)applyiPhone5HeightDelta:(float)hDelta forView:(UIView*)view{
    CGRect f0 = view.frame;
    CGRect f = CGRectMake(f0.origin.x, f0.origin.y, f0.size.width, f0.size.height+hDelta);
    [Utils applyiPhone5Frame:f forView:view];
}





+(BOOL)isIpad{
	if ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound) {
		return YES;
	}
	else {
		return NO;
	}
}
+(float)iphoneHeight {
    return kScreenBounds.size.height;
}

+(BOOL)hasRetinaDisplay
{
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
        return YES;
    else
        return NO;
}

+(float)heightWithText:(NSString*)text andFont:(UIFont*)font andMaxWidth:(float)maxWidth {
    return [text boundingRectWithSize:CGSizeMake(maxWidth, kScreenBounds.size.height)
                              options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:@{NSFontAttributeName:font}
                              context:nil].size.height;
}




@end
