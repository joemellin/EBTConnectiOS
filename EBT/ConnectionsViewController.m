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
#import "GroupCellTableViewCell.h"

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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayList count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        GroupCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
        if(!cell) {
            cell = [[GroupCellTableViewCell alloc] initWithDelegate:self];
            [cell initCell];
        }
        return cell;
    } else {
        ConnectionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionsCell"];
        if(!cell) {
            cell = [[ConnectionsCell alloc] initWithDelegate:self];
            [cell initCell];
        }

        NSDictionary* item = self.displayList[indexPath.row-1];
        [cell fillCell:item forRow:(int)indexPath.row-1];
        return cell;
    }
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
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [Utils alertMessage:[error localizedDescription]];
    }];
}

-(void) conferenceCall {
    
    NSString* urlStr = [NSString stringWithFormat:@"%@telegroup_calls?auth_token=%@",kBaseURL, [Utils setting:kSessionToken]];
    HTTPRequestManager *manager = [[HTTPRequestManager alloc] init];
    
    [manager.httpOperation POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"error"]) {
            [Utils alertMessage:[responseObject objectForKey:@"error"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [Utils alertMessage:[error localizedDescription]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
