//
//  Tool5ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "Tool1ViewController.h"
#import "SelectStateViewController.h"
@interface Tool1ViewController () {
    IBOutlet UILabel *_message;
    IBOutlet UIImageView *_imageView;
}
@end

@implementation Tool1ViewController

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
    [self setNavTitle:@"Sanctuary"];
    
    self.titles = @[
                     @"Take a deep breath...",
                     @"Shoulders back... Assume Body at 1.",
                     @"Lovingly observe yourself.",
                     @"Connect with your sanctuary, the safe place within.",
                     @"Feel a wave of compassion for yourself.",
                     @"Feel a wave of compassion for others.",
                     @"Feel a wave of compassion for all living beings.",
                     @"Feel a surge of joy!",
                     ];
    
    // Do any additional setup after loading the view from its nib.
    float delta = kiPhone5HeightDelta/2;
    
    _message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, 100)];
    _message.numberOfLines = 0;
    _message.textColor = kDarkGrayTextColor;
    _message.text =  self.titles[self.currentIndex];
    _message.backgroundColor= [UIColor clearColor];
    _message.font = [UIFont boldSystemFontOfSize:22];
    _message.textAlignment = NSTextAlignmentCenter;
    [Utils applyiPhone4YDelta:-delta forView:_message];
    [self.view addSubview:_message];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Tool1-%i", self.currentIndex]]];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.frame = CGRectMake(0, 150, kScreenBounds.size.width, kScreenBounds.size.height-150);
    [self.view addSubview:_imageView];
    
    [super viewDidLoad];
}

-(void)next{
    if (self.currentIndex == self.titles.count - 1) {
        SelectStateViewController* vc = [[SelectStateViewController alloc] initWithNibName:@"SelectStateViewController" bundle:nil];
        vc.isRestartMode = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        Tool1ViewController* vc = [[Tool1ViewController alloc] initWithNibName:@"Tool1ViewController" bundle:nil];
        vc.currentIndex = self.currentIndex + 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
