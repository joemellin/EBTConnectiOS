//
//  Tool4ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "Tool4ViewController.h"
#import "SelectStateViewController.h"
@interface Tool4ViewController ()

@end

@implementation Tool4ViewController

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
    [super viewDidLoad];
    [self setNavTitle:@"Cycle Tool"];
    [self addRightArrowButton];
    
    
    self.displayList = @[
                         @"Describe what is going on:",
                         @"Express Anger:",
                         @"Express Sadness:",
                         @"Express Fear:",
                         @"Express Guilt:",
                         @"Unreasonable Expectation:",
                         @"Reasonable Expectation:"
                         ];

    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    imageView.image = [UIImage imageNamed:@"describebar"];
    [self setViewFrame:imageView];
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(15 , 0, 300, 50)];
    label.numberOfLines = 0;
    label.textColor = kGrayTextColor;
    label.text =  displayList[self.currentIndex]; ;
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    //label.textAlignment = UITextAlignmentCenter;
    [imageView addSubview:label];
    [self.view addSubview:imageView];
    
    float height = 200;
    if (!kIsiPhone5) {
        height = height - kiPhone5HeightDelta + 10;
    }
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 60, 300, height)];
    textView.delegate = self;
    textView.text = kCyclePlaceholderText;
    
    NSDictionary* dict;
    //NSDictionary* dict = [Utils setting:kCycleToolNoteDict];
    if (dict[ displayList[self.currentIndex]]) {
         textView.text = dict[ displayList[self.currentIndex]];
    }
    textView.font = [UIFont systemFontOfSize:15];
    textView.textColor = [UIColor lightGrayColor]; //optional
    textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textView];
    [textView becomeFirstResponder];
    myTextView = textView;

}

-(void)next{
    NSMutableDictionary* dict = [[Utils setting:kCycleToolNoteDict] mutableCopy];
    if (!dict) {
        dict = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    dict[ displayList[self.currentIndex]] = myTextView.text;
    //[Utils setSettingForKey:kCycleToolNoteDict withValue:dict];
    
    if (self.currentIndex == displayList.count - 1) {
        SelectStateViewController* vc = [[SelectStateViewController alloc] initWithNibName:@"SelectStateViewController" bundle:nil];
        vc.isRestartMode = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        Tool4ViewController* vc = [[Tool4ViewController alloc] initWithNibName:@"Tool4ViewController" bundle:nil];
        vc.currentIndex = self.currentIndex + 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
        
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:kCyclePlaceholderText]) {
        textView.text = @"";
        textView.textColor = kDarkGrayTextColor; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = kCyclePlaceholderText;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
