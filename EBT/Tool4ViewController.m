//
//  Tool4ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "Tool4ViewController.h"
#import "SelectStateViewController.h"
#import "AcceptStateViewController.h"

@interface Tool4ViewController () <UITextViewDelegate> {
    NSArray *_placeHolders;
}
@end

@implementation Tool4ViewController

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
    [self setNavTitle:@"Cycle Tool"];
    
    self.titles = @[
                 @"Just The Facts...",
                 @"I feel angry that...",
                 @"I feel sad that...",
                 @"I feel afraid that...",
                 @"I feel guilty that...",
                 @"What is my unreasonable expectation?",
                 @"What is my reasonable expectation?",
                 @"Grind In the New Expectation"
                 ];
    self.details = @[
                 @"The situation is...\nWhat I'm most stressed about is...",
                 @"Unlock the circuit with A+ anger.\nI feel angry that... I can't stand that... I hate it that...",
                 @"Switch the circuit by taking a deep breath.\nConnect with yourself and feel your sadness.\nI feel sad that...",
                 @"Connect with yourself and feel your fear.\nI feel afraid that...",
                 @"Connect with yourself and describe your part of it.\nKeep this in mind as you identify your unreasonable expectation.",
                 @"Of course I would do what I feel guilty for doing,\n because the wire in my brain (my unreasonable expectation) is...",
                 @"State the reasonable expectation,\n(the opposite of the unreasonable one).\nExamples:\nI DO have power!\n(rather than I do not have power).\nI CANNOT get my safety from sugar\n(rather than I get my safety from sugar).",
                 @"Use the Spiral up Grind In to lock in the new circuit.\n * Slow Statements \n * 3+ Ramped Up Statements \n * 3+ Joy Statements"
                 ];
    
    _placeHolders = @[@"The situation is... What I'm most stressed about is...",
                      @"I feel angry that... I can't stand that... I hate it that...",
                      @"I feel sad that...",
                      @"I feel afraid that...",
                      @"I feel guilty that...",
                      @"My unreasonable expectation is...",
                      @"My reasonable expectation is...",
                      @"Repeat your reasonable expectation 10+ times..."
                      ];
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = [[UIImage imageNamed:@"describebar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setViewFrame:imageView];
    
    //setting title
    UILabel* title;
    title = [[UILabel alloc] init];
    title.numberOfLines = 0;
    title.textColor = kBlueTextColor;
    title.text =  self.titles[self.currentIndex]; ;
    title.backgroundColor= [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:19];
    title.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:title];
    [self.view addSubview:imageView];
    
    
    float titleHeight = [Utils heightWithText:title.text andFont:title.font andMaxWidth:kScreenBounds.size.width-20];
   
    title.frame = CGRectMake(10, 10, kScreenBounds.size.width-20, titleHeight);
    float textViewStart = titleHeight+20;
    imageView.frame = CGRectMake(0, 0, kScreenBounds.size.width, textViewStart);

    if(self.currentIndex < self.titles.count) {
        UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(10, textViewStart,
                                                                            kScreenBounds.size.width-20,
                                                                            kScreenBounds.size.height-textViewStart-150)];
        textView.delegate = self;
        textView.text = kCyclePlaceholderText;
        
        NSDictionary* dict;
        //NSDictionary* dict = [Utils setting:kCycleToolNoteDict];
        if (dict[ self.titles[self.currentIndex]]) {
             textView.text = dict[ self.titles[self.currentIndex]];
        } else {
            textView.text = _placeHolders[self.currentIndex];
        }
        textView.font = [UIFont systemFontOfSize:17];
        textView.textColor = [UIColor lightGrayColor]; //optional
        textView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:textView];
        myTextView = textView;
    }
    
    [super viewDidLoad];
    
    [self addRightButtonWithImage:[UIImage imageNamed:@"bluearrow"] target:self selector:@selector(next)];
    [self addLeftBackButtonHome];
}

-(void) back {
    [self.navigationController popToViewController:[Utils appDelegate].tabBarViewController animated:YES];
}

-(void)next {
    if (self.currentIndex == self.titles.count - 1) {
        AcceptStateViewController* vc = [[AcceptStateViewController alloc] init];
        int state = [[Utils setting:@"currentStateSetting"] intValue];
        vc.state = state;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSMutableDictionary* dict = [[Utils setting:kCycleToolNoteDict] mutableCopy];
        if (!dict) {
            dict = [NSMutableDictionary dictionaryWithCapacity:10];
        }
        dict[ self.titles[self.currentIndex]] = myTextView.text;
        //[Utils setSettingForKey:kCycleToolNoteDict withValue:dict];
        
        Tool4ViewController* vc = [[Tool4ViewController alloc] init];
        vc.currentIndex = self.currentIndex + 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Text View delegates

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:_placeHolders[self.currentIndex]]) {
        textView.text = @"";
        textView.textColor = kDarkGrayTextColor; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = _placeHolders[self.currentIndex];
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        // Find the next entry field
        [textView resignFirstResponder];
    }  
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
