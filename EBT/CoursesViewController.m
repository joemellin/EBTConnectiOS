//
//  CoursesViewController.m
//  EBT
//
//  Created by Adi on 3/18/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "CoursesViewController.h"
#import "YTVimeoExtractor.h"
#import "CoursesCell.h"
#import "HTTPRequestManager.h"

@interface CoursesViewController ()
@property (nonatomic, strong) MPMoviePlayerViewController *playerViewController;
@end

@implementation CoursesViewController

- (void)viewDidLoad
{
    needsNavBar = YES;
    [self setupTableView];
    [self setNavTitle:@"Courses"];
    
    [self getCourses];

    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    // Do any additional setup after loading the view from its nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    CoursesCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(!cell) {
        cell = [[CoursesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initCell];
    }
    
    NSDictionary* item = self.displayList[[indexPath row]];
    [cell fillCell:item forRow:(int)indexPath.row];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showLoadingView];
    NSDictionary* item = self.displayList[[indexPath row]];
    [YTVimeoExtractor fetchVideoURLFromURL:item[@"vimeo_src"]
                                   quality:YTVimeoVideoQualityHigh
                         completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
                             [self hideLoadingView];
                             if (error) {
                                 // handle error
                                 NSLog(@"Video URL: %@", [videoURL absoluteString]);
                             } else {
                                 // run player
                                 self.playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
                                 [self.playerViewController.moviePlayer prepareToPlay];
                                 [self presentViewController:self.playerViewController animated:YES completion:nil];
                             }
                         }];
   	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getCourses {
    NSString* urlStr = [NSString stringWithFormat:@"%@media",kBaseURL];
    
    HTTPRequestManager *manager = [[HTTPRequestManager alloc] init];
    
    //show loading indicator
    
    [manager.httpOperation GET:urlStr parameters:@{@"auth_token": [Utils setting:kSessionToken ]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"error"]) {
            [Utils alertMessage:[responseObject objectForKey:@"error"]];
        } else {
            self.displayList = responseObject[@"media"];
            [myTableView reloadData];
        }
        [self hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils alertMessage:[error localizedDescription]];
    }];
}

@end
