//
//  CoursesViewController.m
//  EBT
//
//  Created by Adi on 3/18/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "CoursesViewController.h"

@interface CoursesViewController ()

@end

@implementation CoursesViewController

- (void)viewDidLoad
{
    needsNavBar = YES;
    [self setupTableView];
    [super viewDidLoad];
    [self setNavTitle:@"Courses"];
    
    // Do any additional setup after loading the view from its nib.
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
    imageView.image = [self getImageFromUrlString:item[@"supporter_image_url"] tag:imageView.tag];
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
    label.text = @"";
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
   	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
