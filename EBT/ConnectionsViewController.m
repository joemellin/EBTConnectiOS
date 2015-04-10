//
//  ConnectionsViewController.m
//  EBT
//
//  Created by Adi on 3/18/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "MemberViewController.h"
#import "CallingViewController.h"
#import <UIImageView+AFNetworking.h>
#import "ConnectionsCell.h"
#import "MessagingViewController.h"
#import "HTTPRequestManager.h"

@interface ConnectionsViewController ()

@end

@implementation ConnectionsViewController

- (void)viewDidLoad
{
    needsNavBar = YES;
    [self setupTableView];
    [self setNavTitle:@"Your Connections"];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // Do any additional setup after loading the view from its nib.
    [Utils appDelegate].connectionsController = self;
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestGroup];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"ConnectionsCell";
    ConnectionsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(!cell) {
        cell = [[ConnectionsCell alloc] initWithDelegate:self];
        [cell initCell];
    }

    NSDictionary* item = self.displayList[[indexPath row]];
    [cell fillCell:item forRow:(int)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   	
}

#pragma mark - functions for buttons on cell
-(void) callSelected:(UIButton*) sender {
    NSDictionary *item = self.displayList[sender.tag];
    [self callCommunity:[item[kID] intValue] withName:item[kName]];
    CallingViewController *callingVC = [[CallingViewController alloc] init];
    callingVC.hidesBottomBarWhenPushed = YES;
    callingVC.name = item[kName];
    [self.navigationController pushViewController:callingVC animated:YES];
}

-(void) messageSelected:(UIButton*) sender {
    MessagingViewController *messageVC = [[MessagingViewController alloc] init];
    messageVC.hidesBottomBarWhenPushed = YES;
    messageVC.currentItem = self.displayList[sender.tag];
    [self.navigationController pushViewController:messageVC animated:YES];
}

#pragma mark - network requests

-(void)requestGroup{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self showLoadingView];
    
    NSDictionary* params = [Utils setting:kUserInfoDict];
    NSString* urlStr = [NSString stringWithFormat:@"%@groups/%@?auth_token=%@",kBaseURL, [[params objectForKey:kGroup] objectForKey:kID], [Utils setting:kSessionToken]];
    
    HTTPRequestManager *manager = [[HTTPRequestManager alloc] init];
    
    [manager.httpOperation GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"error"]) {
            [Utils alertMessage:[responseObject objectForKey:@"error"]];
        } else {
            [self hideLoadingView];
            if (responseObject && responseObject[@"members"]) {
                self.currentItem = [responseObject mutableCopy];
                self.displayList = self.currentItem[@"members"];
                [myTableView reloadData];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils alertMessage:[error localizedDescription]];
    }];
    
    
    MyURLConnection* myconn = [[MyURLConnection alloc] initWithURL:urlStr target:self
                                                 succeededCallback:@selector(requestSucceeded:myURLConnection:)
                                                    failedCallback:@selector(requestFailed:myURLConnection:)
                                                           context:[NSNumber numberWithInt:1]];
    [myconn get];

    
}

-(void) callCommunity:(int) calledId withName:(NSString*)name {
    NSString* urlStr = [NSString stringWithFormat:@"%@community_connections",kBaseURL];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [Utils setting:kSessionToken],@"auth_token",
                                   [NSNumber numberWithInteger:calledId], @"called_id",
                                   nil];
    
    HTTPRequestManager *manager = [[HTTPRequestManager alloc] init];
    
    [manager.httpOperation POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"error"]) {
            [Utils alertMessage:[responseObject objectForKey:@"error"]];
        } else {
            CallingViewController *callingVC = [[CallingViewController alloc] init];
            callingVC.hidesBottomBarWhenPushed = YES;
            callingVC.name = name;
            [self.navigationController pushViewController:callingVC animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils alertMessage:[error localizedDescription]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
