//
//  SelectStateViewController.m
//  EBT
//
//  Created by ross chen on 8/13/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "SelectStateViewController.h"
#import "StateDetailViewController.h"
@interface SelectStateViewController () {
    NSArray *_states;
}
@end

@implementation SelectStateViewController

- (id)init
{
    self = [super init];
    if (self) {
         _states = @[@"1 Feeling Great", @"2 Feeling Good", @"3 A Little Stressed", @"4 Definitely Stressed", @"5 Stressed Out"];
    }
    return self;
}

- (void)viewDidLoad
{
    needsNavBar = YES;
    [super viewDidLoad];
    [self setNavTitle:@"What is Your State?"];
    if (self.isRestartMode) {
        [self setNavTitle:@"What is Your State Now?"];

    }
    [self setupTableView];
    
    float y =410;
    if (!kIsiPhone5) {
        y = 370;
    }
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(160-12, y, 0, 0)];
    imageView.image = [UIImage imageNamed:@"bell"];
    [self setViewFrame:imageView];
    //[self.view addSubview:imageView];
	
	
	
}



-(void)setupTableView{
	float offsetY = 0;
	myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, offsetY, kScreenBounds.size.width, kScreenBounds.size.height)
											  style:UITableViewStyleGrouped];
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
	
	return 70;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:25];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = kDarkGrayTextColor;
    cell.textLabel.text = [_states objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.state = [indexPath row];
    if (!self.isRestartMode) {
        [self requestCheckIn];

    }
    else{
        StateDetailViewController* vc = [[StateDetailViewController alloc] init];
        vc.state = self.state;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)requestCheckIn{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [Utils setting:kSessionToken ],@"auth_token",
                                 nil];
    dict[@"initial_state"] = [NSString stringWithFormat:@"%d",self.state+1];
        
    
	NSString* urlStr = [NSString stringWithFormat:@"%@checkins",kBaseURL];
    
    
	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    
	
	MyURLConnection* myconn = [[MyURLConnection alloc] initWithURL:urlStr target:self
												 succeededCallback:@selector(requestSucceeded:myURLConnection:)
													failedCallback:@selector(requestFailed:myURLConnection:)
														   context:[NSNumber numberWithInt:1]];
    
    
    [myconn post:dict];
    
    [self showLoadingView];
	
}


-(void)requestSucceededResultHandler:(id)context result:(NSString*)result{
    NSLog(@"result:%@",result);
    
    if ([context intValue] == 1) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        //[Utils alertMessage:dict[@"success"]];
        if (dict[kCheckinID]) {
            [Utils setSettingForKey:kCheckinID withValue:dict[kCheckinID]];
            [Utils setSettingForKey:kInitialState withValue:[NSNumber numberWithInt:self.state]];

        }
        StateDetailViewController* vc = [[StateDetailViewController alloc] init];
        vc.state = self.state;
        [self.navigationController pushViewController:vc animated:YES];
	}
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
