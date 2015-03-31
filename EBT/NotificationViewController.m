//
//  NotificationViewController.m
//  EBT
//
//  Created by ross chen on 8/28/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "NotificationViewController.h"
#import "MemberViewController.h"
#import <UIImageView+AFNetworking.h>

@interface NotificationViewController ()

@end

@implementation NotificationViewController

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
    needsNavBar = YES;
    [self setupTableView];
    [super viewDidLoad];
    [self setNavTitle:@"Notifications"];
    
    // Do any additional setup after loading the view from its nib.
}

-(NSString*)timelineXValueForItem:(NSDictionary*)item{

    NSDate* date =   date = [Utils dateFromISOString:item[@"supported_at"]];
   
    int delta = abs((int)[date timeIntervalSinceNow]);
    int hour = delta / 3600;
    int min = (((int)delta) % 3600) / 60;
    if (hour > 0) {
        int day = hour / 24;
        if (day > 0) {
             if (day == 1) {
                 return [NSString stringWithFormat:@"%d day",day];
             }
             else{
                 return [NSString stringWithFormat:@"%d days",day];

             }
        }
        if (hour == 1) {
            return [NSString stringWithFormat:@"%d hour",hour];
        }
        else{
            return [NSString stringWithFormat:@"%d hours",hour];
            
        }
    }
    else if (min > 0) {
        if (min == 1) {
            return [NSString stringWithFormat:@"%d minute",min];
        }
        else{
            return [NSString stringWithFormat:@"%d minutes",min];
            
        }
        
    }
    else{
        return @"Now";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    float x = 13;
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 15, 40, 40)];
    imageView.tag = kBaseTag + [indexPath row];
    NSDictionary* item = self.displayList[[indexPath row]];
    [imageView setImageWithURL:[NSURL URLWithString:item[@"supporter_image_url"]]];
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.layer.borderColor = [kDarkGrayTextColor CGColor];
    imageView.layer.borderWidth = 0.5;
    imageView.clipsToBounds = YES;
    [cell.contentView addSubview:imageView];

    
    x += 50;
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(x , 10, 230, 25)];
    label.numberOfLines = 1;
    label.textColor = kGrayTextColor;
    label.text =  [self timelineXValueForItem:item];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    //label.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x , 35, 230, 25)];
    label.numberOfLines = 1;
    label.textColor = kDarkGrayTextColor;
    label.text =  [NSString stringWithFormat:@"%@ supported your checkin.",item[kName]] ;
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    //label.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 68, 0, 0)];
    imageView.image = [UIImage imageNamed:@"splitline.png"];
    [self setViewFrame:imageView];
    [cell.contentView addSubview:imageView];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* item = self.displayList[[indexPath row]];

    MemberViewController* vc = [[MemberViewController alloc] init];
    vc.isMe = NO ;
    vc.imageCacheDict = self.imageCacheDict;
    vc.currentItem = item;
      
    [self.navigationController pushViewController:vc animated:YES];
   	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
