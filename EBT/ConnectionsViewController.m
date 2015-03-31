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
    NSDictionary* item = self.displayList[[indexPath row]];
    
    MemberViewController* vc = [[MemberViewController alloc] init];
    vc.imageCacheDict = self.imageCacheDict;
    vc.currentItem = item;
    
    [self.navigationController pushViewController:vc animated:YES];
   	
}

#pragma mark - functions for buttons on cell
-(void) callSelected:(UIButton*) sender {
    NSDictionary *item = self.displayList[sender.tag];
    [self requestCommunityCall:[item[kID] intValue]];
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
    NSDictionary* dict = [Utils setting:kUserInfoDict];
    NSString* urlStr = [NSString stringWithFormat:@"%@groups/%@?auth_token=%@",kBaseURL, [[dict objectForKey:kGroup] objectForKey:kID], [Utils setting:kSessionToken]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    
    
    MyURLConnection* myconn = [[MyURLConnection alloc] initWithURL:urlStr target:self
                                                 succeededCallback:@selector(requestSucceeded:myURLConnection:)
                                                    failedCallback:@selector(requestFailed:myURLConnection:)
                                                           context:[NSNumber numberWithInt:1]];
    [myconn get];
    [self showLoadingView];
    
}

-(void) requestCommunityCall:(int) calledId {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [Utils setting:kSessionToken],@"auth_token",
                                 [NSNumber numberWithInteger:calledId], @"called_id",
                                 nil];
    NSString* urlStr = [NSString stringWithFormat:@"%@community_connections",kBaseURL];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    
    
    MyURLConnection* myconn = [[MyURLConnection alloc] initWithURL:urlStr target:self
                                                 succeededCallback:@selector(requestSucceeded:myURLConnection:)
                                                    failedCallback:@selector(requestFailed:myURLConnection:)
                                                           context:[NSNumber numberWithInt:1]];
    [myconn post:dict];
}

-(void)requestSucceededResultHandler:(id)context result:(NSString*)result{
    NSLog(@"result:%@",result);
    
    [self hideLoadingView];
    
    if ([context intValue] == 1) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if (dict && dict[@"members"]) {
            self.currentItem = [dict mutableCopy];
            self.displayList = self.currentItem[@"members"];
            [myTableView reloadData];
        }
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
