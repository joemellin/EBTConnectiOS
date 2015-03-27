//
//  CoursesViewController.m
//  EBT
//
//  Created by Adi on 3/18/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "CoursesViewController.h"
#import "YTVimeoExtractor.h"

@interface CoursesViewController ()
@property (nonatomic, strong) MPMoviePlayerViewController *playerViewController;
@end

@implementation CoursesViewController

- (void)viewDidLoad
{
    needsNavBar = YES;
    [self setupTableView];
    [super viewDidLoad];
    [self setNavTitle:@"Courses"];
    
    self.displayList = @[@{@"name":@"Privacy Policy", @"url":@"https://vimeo.com/115316692"}
                            ];
    
    // Do any additional setup after loading the view from its nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary* item = self.displayList[[indexPath row]];
    
    cell.textLabel.text = item[kName];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showLoadingView];
    NSDictionary* item = self.displayList[[indexPath row]];
    [YTVimeoExtractor fetchVideoURLFromURL:item[kUrl]
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

@end
