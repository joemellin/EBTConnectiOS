//
//  BaseListViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "BaseListViewController.h"

@interface BaseListViewController ()

@end

@implementation BaseListViewController

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
    
    myTableView.dataSource = self;
	myTableView.delegate = self;
	myTableView.backgroundColor = [UIColor clearColor];
	myTableView.separatorColor = [UIColor clearColor];
    myTableView.scrollEnabled = NO;
	// Do any additional setup after loading the view.
}



-(void)setupTableView{
	CGRect screen = [[UIScreen mainScreen] bounds];
	float offsetY = 0;
	myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, offsetY, 320, kIphoneHeight-20-44)
											  style:UITableViewStylePlain];
   
	[self.view addSubview:myTableView];
}



#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [displayList count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 70;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = [NSString stringWithFormat:@"%d", [indexPath row]+1];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:25];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.textColor = kDarkGrayTextColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 68, 0, 0)];
    imageView.image = [UIImage imageNamed:@"splitline.png"];
    [self setViewFrame:imageView];
    [cell.contentView addSubview:imageView];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
   	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
