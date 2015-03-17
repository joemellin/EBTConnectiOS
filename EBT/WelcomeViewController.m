//
//  WelcomeViewController.m
//  EBT
//
//  Created by ross chen on 8/7/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    needsNavBar = NO;
    [super viewDidLoad];

    [self setupHorizontalScrollView];
    
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    tap2.cancelsTouchesInView = YES;
    tap2.delaysTouchesBegan = YES;
    [self.view addGestureRecognizer:tap2];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setupHorizontalScrollView{
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kIphoneHeight)];
    myScrollView = scrollView;
    scrollView.delegate = self;
    
    [scrollView setBackgroundColor:[UIColor blackColor]];
    [scrollView setCanCancelContentTouches:NO];
    
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.clipsToBounds = NO;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    imageCount = 6;
    NSUInteger nimages = 0;
    for (;nimages < imageCount ; nimages++) {
        NSString* tpl = @"%d-5.jpg";
        if (!kIsiPhone5) {
            tpl = @"%d.jpg";
        }
        NSString *imageName = [NSString stringWithFormat:tpl, (nimages + 1)];
        
        UIImage *image = [UIImage imageNamed:imageName];
        float x = 0;
        
        float lastX = x + 320 * nimages;
        float h = 548;
        if (!kIsiPhone5) {
            h = 460;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(lastX, 0, 320, h)];
        imageView.image = image;
        
        [scrollView addSubview:imageView];
        
    }
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 440, 320, 40)];
    
    pageControl.numberOfPages = nimages;
    pageControl.autoresizingMask = UIViewAutoresizingNone;
    
    [scrollView setContentSize:CGSizeMake(imageCount*320, [scrollView bounds].size.height)];
    [self.view addSubview:scrollView];
    [Utils applyiPhone4YDelta:-kiPhone5HeightDelta forView:pageControl];
    
     [self.view addSubview:pageControl];
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(10, 486, 300, 50);
	[button setBackgroundImage:[UIImage imageNamed:@"continuebutton"] forState:UIControlStateNormal];
    [button setTitle:@"Continue" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    nextButton = button;
    [self.view addSubview:button];
    [Utils applyiPhone4YDelta:-kiPhone5HeightDelta forView:button];

}

-(void)next{
    if (currentIndex == imageCount-1) {
        [Utils setSettingForKey:kWelcomeShowed withValue:@"1"];
        [Utils showSubViewWithName:@"GroupViewController" withDelegate:self];
        return;
    }
    [myScrollView scrollRectToVisible:CGRectMake((currentIndex+1)*320, 0, 320, 10) animated:YES];
    int page = currentIndex+1;
    currentIndex = page;

    [pageControl setCurrentPage:page];
    if (page == imageCount-1) {
        [nextButton setTitle:@"Join Group" forState:UIControlStateNormal];
    }
    else{
        [nextButton setTitle:@"Continue" forState:UIControlStateNormal];
        
    }
    
}

-(void)doubleTapped:(UITapGestureRecognizer*)sender{
   // [self back];
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    float pageWidth = 320;
    
    int page = sender.contentOffset.x / pageWidth;
    currentIndex = page;
    [pageControl setCurrentPage:page];
    if (page == imageCount-1) {
        [nextButton setTitle:@"Join Group" forState:UIControlStateNormal];
    }
    else{
        [nextButton setTitle:@"Continue" forState:UIControlStateNormal];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
