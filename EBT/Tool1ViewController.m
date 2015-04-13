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

- (id)init
{
    self = [super init];
    if (self) {
        // Customization
    }
    return self;
}

- (void)viewDidLoad
{
    needsNavBar = YES;
    [self setNavTitle:@"Sanctuary"];
    
    self.titles = @[
                     @"Take a deep breath...",
                     @"Feel compassion for yourself...",
                     @"Feel compassion for others...",
                     @"Feel compassion for all living beings...",
                     @"Feel a surge of joy!"
                     ];
    
    _message = [[UILabel alloc] init];
    _message.numberOfLines = 0;
    _message.textColor = kOffWhite;
    _message.shadowColor = [UIColor blackColor];
    _message.shadowOffset = CGSizeMake(0, 1);
    _message.textAlignment = NSTextAlignmentCenter;
    _message.text =  self.titles[self.currentIndex];
    _message.backgroundColor= [UIColor clearColor];
    _message.font = [UIFont systemFontOfSize:50];
    
    float height = [Utils heightWithText:_message.text andFont:_message.font andMaxWidth:kScreenBounds.size.width-40]+30;
    _message.frame = CGRectMake(20, (kScreenBounds.size.height-64)/2-height/2-60, kScreenBounds.size.width-40, height);
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Tool1-%i", self.currentIndex]]];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.frame = CGRectMake(0, 0, kScreenBounds.size.width, kScreenBounds.size.height);
    _imageView.clipsToBounds = YES;
    [self.view addSubview:_imageView];
    [self.view addSubview:_message];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
