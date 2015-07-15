//
//  SelectStateViewController.m
//  EBT
//
//  Created by ross chen on 8/13/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "SelectStateViewController.h"
#import "AcceptStateViewController.h"

@interface SelectStateViewController () {
    NSArray *_states;
}
@end

@implementation SelectStateViewController

- (id)init
{
    self = [super init];
    if (self) {
         _states = @[@"1 Feeling Great!", @"2 Feeling Good", @"3 A Little Stressed", @"4 Definitely Stressed", @"5 Stressed Out!"];
    }
    return self;
}

- (void)viewDidLoad
{
    needsNavBar = YES;
    [super viewDidLoad];
    [self setNavTitle:@"What number are you?"];
    [self setupTableView];
    [self addLeftBackButtonHome];
}



-(void)setupTableView{
	myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, kScreenBounds.size.height)
											  style:UITableViewStylePlain];
    myTableView.dataSource = self;
	myTableView.delegate = self;
	myTableView.backgroundColor = [UIColor clearColor];
    myTableView.scrollEnabled = NO;
    myTableView.tableHeaderView = [[UIView alloc] init];
	[self.view addSubview:myTableView];
}



#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_states count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return (kScreenBounds.size.height-120)/[_states count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:25];
    cell.textLabel.textColor = kDarkGrayTextColor;
    cell.textLabel.text = [_states objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.state = (int)[indexPath row];
    [self useTool];
}

-(void)useTool {
    if (_state == 0) {
        [Utils showSubViewWithName:@"Tool1ViewController" withDelegate:self];
    }
    else if (_state == 1) {
        [Utils showSubViewWithName:@"Tool2ViewController" withDelegate:self];
    }
    else if (_state == 2) {
        [Utils showSubViewWithName:@"Tool3ViewController" withDelegate:self];
    }
    else if (_state == 3) {
        [Utils showSubViewWithName:@"Tool4ViewController" withDelegate:self];
    }
    else if (_state == 4) {
        [Utils showSubViewWithName:@"Tool5ViewController" withDelegate:self];
    }
    [Utils setSettingForKey:@"currentStateSetting" withValue:[NSNumber numberWithInt:_state]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
