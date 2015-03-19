//
//  Tool2S3ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "Tool2S3ViewController.h"

@interface Tool2S3ViewController ()

@end

@implementation Tool2S3ViewController

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
    needsNavBar = YES;
    [self setupTableView];
    
    [super viewDidLoad];
    
    [self setNavTitle:@"Feelings Check"];
    self.displayList = [Utils setting:kSelectedFeelings];
    
    [myTableView reloadData];
    
      
    [self addTableDescription:@"What is your strongest feeling?"];

}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = self.displayList[[indexPath row]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = kDarkGrayTextColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 68, 0, 0)];
    imageView.image = [UIImage imageNamed:@"splitline.png"];
    [self setViewFrame:imageView];
    [cell.contentView addSubview:imageView];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* feeling = self.displayList[[indexPath row]];
    [Utils setSettingForKey:kSelectedFeeling withValue:feeling];
    [Utils showSubViewWithName:@"Tool2S4ViewController" withDelegate:self];

   	
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
