//
//  ConnectionsViewController.m
//  EBT
//
//  Created by Adi on 3/18/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "MemberViewController.h"
#import "MessageViewController.h"
#import "CallingViewController.h"

@interface ConnectionsViewController ()

@end

@implementation ConnectionsViewController

- (void)viewDidLoad
{
    needsNavBar = YES;
    [self setupTableView];
    [super viewDidLoad];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self setNavTitle:@"Your Connections"];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestGroup];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton * message = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton * call = [UIButton buttonWithType:UIButtonTypeCustom];
        [message setImage:[UIImage imageNamed:@"messageuser"] forState:UIControlStateNormal];
        [call setImage:[UIImage imageNamed:@"phoneuser"] forState:UIControlStateNormal];
        
        call.frame = CGRectMake(kScreenBounds.size.width - 40, 5, 30, 30);
        call.tag = indexPath.row;
        message.frame = CGRectMake(call.frame.origin.x - 40, 5, 30, 30);
        message.tag = indexPath.row;
        [call addTarget:self action:@selector(callSelected:) forControlEvents:UIControlEventTouchUpInside];
        [message addTarget:self action:@selector(messageSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:message];
        [cell addSubview:call];
    }
    
    NSDictionary* item = self.displayList[[indexPath row]];

    cell.textLabel.text = item[kName];
    [cell.imageView setImage:[UIImage imageNamed:@"tab_state"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* item = self.displayList[[indexPath row]];
    
    MemberViewController* vc = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:nil];
    vc.imageCacheDict = self.imageCacheDict;
    vc.currentItem = item;
    
    [self.navigationController pushViewController:vc animated:YES];
   	
}

#pragma mark - functions for buttons on cell
-(void) callSelected:(UIButton*) sender {
    NSDictionary *item = self.displayList[sender.tag];
//    [self requestCommunityCall:[item[kID] intValue]];
    CallingViewController *callingVC = [[CallingViewController alloc] init];
    callingVC.name = item[kName];
    [self.navigationController pushViewController:callingVC animated:YES];
}

-(void) messageSelected:(UIButton*) sender {
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    messageVC.currentItem = self.displayList[sender.tag];
    [self.navigationController pushViewController:messageVC animated:YES];
}

#pragma mark - network requests

-(IBAction)requestGroup{
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
                                 [Utils setting:kSessionToken ],@"auth_token",
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
