//
//  MessagesViewController.m
//  EBT
//
//  Created by Adi on 3/18/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "MessagesViewController.h"
#import "MemberViewController.h"
#import "MessagesCell.h"
#import "HTTPRequestManager.h"
#import "MessagingViewController.h"
#import "TabBarViewController.h"

@interface MessagesViewController () {
    NSDictionary *_providerInfo;
    UIRefreshControl *_refreshControl;
}

@end

@implementation MessagesViewController

- (void)viewDidLoad
{
    needsNavBar = YES;
    [self setupTableView];
    [self setNavTitle:@"Messages"];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self requestUserMessages];
    [self addRightButtonWithImage:[UIImage imageNamed:@"grayPlus"] target:self selector:@selector(showConnections)];
    
    
    [super viewDidLoad];
    _refreshControl = [[UIRefreshControl alloc]init];
    [myTableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(requestUserMessages) forControlEvents:UIControlEventValueChanged];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScreen) name:@"UpdateMessageScreens" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self requestUserMessages];
}

-(void) refreshScreen {
    [myTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayList count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MessagesCell";
    MessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(!cell) {
        cell = [[MessagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        [cell initCell];
    }
    
    NSUInteger row = indexPath.row;
    if(_providerInfo != nil && row == 0) {
        [cell fillCell:_providerInfo forRow:0];
        return cell; // return for provider cell
    } else if(_providerInfo != nil) {
        row -= 1;
    }
    
    NSDictionary* item = self.displayList[row];
    [cell fillCell:item forRow:(int)indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessagingViewController *messageVC = [[MessagingViewController alloc] init];
    messageVC.hidesBottomBarWhenPushed = YES;
    
    NSDictionary *unmutableDict = self.displayList[indexPath.row][kSender];
    NSMutableDictionary *dict = [unmutableDict mutableCopy];
    [dict setObject:unmutableDict[kFname] forKey:@"name"];
    messageVC.currentItem = dict;
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) requestUserMessages {
    [self requestProvider];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@messages/",kBaseURL];

    HTTPRequestManager *manager = [[HTTPRequestManager alloc] init];
    
    //show loading indicator

    [manager.httpOperation GET:urlStr parameters:@{@"auth_token": [Utils setting:kSessionToken ]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"error"]) {
            [Utils alertMessage:[responseObject objectForKey:@"error"]];
        } else {
            self.displayList = responseObject;
            [myTableView reloadData];
        }
        [self hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils alertMessage:[error localizedDescription]];
    }];
//    [self showLoadingView];
}

-(void) requestProvider {
    NSString* urlStr = [NSString stringWithFormat:@"%@messages/provider",kBaseURL];
    
    HTTPRequestManager *manager = [[HTTPRequestManager alloc] init];
    
    //show loading indicator
    
    [manager.httpOperation GET:urlStr parameters:@{@"auth_token": [Utils setting:kSessionToken ]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"error"]) {
            [Utils alertMessage:[responseObject objectForKey:@"error"]];
        } else {
            _providerInfo = responseObject;
            [myTableView reloadData];
        }
        [self hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils alertMessage:[error localizedDescription]];
    }];
//    [self showLoadingView];
}

-(void)requestSucceededResultHandler:(id)context result:(NSString*)result{
    NSLog(@"result:%@",result);
    
    
    
    if ([context intValue] == 1) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if (dict && self.currentItem[@"members"]) {
            self.currentItem = [dict mutableCopy];
            self.displayList = self.currentItem[@"members"];
            [myTableView reloadData];
        }
        
    }
}

-(void) showConnections {
    [[Utils appDelegate].tabBarViewController setSelectedIndex:1];
}
@end
