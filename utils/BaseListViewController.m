//
//  BaseListViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "BaseListViewController.h"

@interface BaseListViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BaseListViewController

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
    [super viewDidLoad];
    
    myTableView.dataSource = self;
	myTableView.delegate = self;
	myTableView.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
}

-(BOOL) shouldAutorotate {
    return  [super shouldAutorotate];
}

-(void)setupTableView{
	myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, kScreenBounds.size.height)
											  style:UITableViewStylePlain];
	[self.view addSubview:myTableView];
}



#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.displayList count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 88;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = [NSString stringWithFormat:@"%d", [indexPath row]+1];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:25];
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
  
   	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
