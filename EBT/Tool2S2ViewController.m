//
//  Tool2S2ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "Tool2S2ViewController.h"

@interface Tool2S2ViewController ()

@end

@implementation Tool2S2ViewController

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
    [self setupTableView];

    [super viewDidLoad];

    [self setNavTitle:@"Feelings Check"];
    [Utils removeSettingForKey:kSelectedFeelings];
    selectedFeelings = [NSMutableArray arrayWithCapacity:3];
    self.displayList = @[
                         @"Angry",@"Grateful",
                         @"Sad",@"Happy",
                         @"Afraid",@"Secure",
                         @"Guilty",@"Proud",
                         @"Tired",@"Rested",
                         @"Tense",@"Relaxed",
                         @"Hungry",@"Satisfied",
                         @"Full",@"Loved",
                         @"Lonely",@"Loving",
                         @"Sick",@"Healthy"
                         
                         ];
    
    [myTableView reloadData];
    
    [self addTableDescription:@"What are your 3 strongest feelings"];

    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.displayList count]/2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 33;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = [indexPath row] * 10 + 0;
    button.frame = CGRectMake(14, 9, 0, 0);
	[button setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];

    [button addTarget:self action:@selector(checkState:) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
    [cell.contentView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = [indexPath row] * 10 + 1;
    button.frame = CGRectMake(175, 9, 0, 0);
	[button setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(checkState:) forControlEvents:UIControlEventTouchUpInside];
	[self setViewFrame:button];
    [cell.contentView addSubview:button];

    
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(45 , 0, 110, 33)];
    label.numberOfLines = 0;
    //label.textColor = [UIColor whiteColor];
    label.text = displayList[[indexPath row] * 2 + 0];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    //label.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(203 , 0, 110, 33)];
    label.numberOfLines = 0;
    //label.textColor = [UIColor whiteColor];
    label.text = displayList[[indexPath row] * 2 + 1];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    //label.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label];


	   
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   	
}

-(void)checkState:(UIButton*)button{
    
    int row = button.tag / 10;
    int col = button.tag % 10;
    int index = row*2 + col;
    NSString* value = displayList[index];
    if (!button.selected && [selectedFeelings count] == 3 && [selectedFeelings indexOfObject:value] == NSNotFound) {
        return;
    }
    button.selected = !button.selected;

    if (button.selected) {
        [selectedFeelings addObject:value];
    }
    else{
        [selectedFeelings removeObject:value];
    }
    if ([selectedFeelings count] == 3) {
        [Utils setSettingForKey:kSelectedFeelings withValue:selectedFeelings];
        [Utils showSubViewWithName:@"Tool2S3ViewController" withDelegate:self];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
