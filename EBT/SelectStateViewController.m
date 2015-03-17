//
//  SelectStateViewController.m
//  EBT
//
//  Created by ross chen on 8/13/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "SelectStateViewController.h"
#import "StateDetailViewController.h"
@interface SelectStateViewController ()

@end

@implementation SelectStateViewController

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
	CGRect screen = [[UIScreen mainScreen] bounds];
	float offsetY = 0;
	myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, offsetY, 320, kIphoneHeight-20)
											  style:UITableViewStylePlain];
    myTableView.dataSource = self;
	myTableView.delegate = self;
	myTableView.backgroundColor = [UIColor clearColor];
	myTableView.separatorColor = [UIColor clearColor];
    myTableView.scrollEnabled = NO;
	[self.view addSubview:myTableView];
}



#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 70;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
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
    self.state = [indexPath row];
    if (!self.isRestartMode) {
        [self requestCheckIn];

    }
    else{
        StateDetailViewController* vc = [[StateDetailViewController alloc] initWithNibName:@"StateDetailViewController" bundle:nil];
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
        StateDetailViewController* vc = [[StateDetailViewController alloc] initWithNibName:@"StateDetailViewController" bundle:nil];
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
