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

@interface MessagesViewController ()

@end

@implementation MessagesViewController

- (void)viewDidLoad
{
    needsNavBar = YES;
    [self setupTableView];
    [self setNavTitle:@"Messages"];
    self.navigationItem.leftBarButtonItem = nil;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    [self requestUserMessages];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self requestUserMessages];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MessagesCell";
    MessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(!cell) {
        cell = [[MessagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        [cell initCell];
    }
    
    NSDictionary* item = self.displayList[[indexPath row]];
    [cell fillCell:item forRow:(int)indexPath.row];
    return cell;
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
    [self showLoadingView];
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
@end
