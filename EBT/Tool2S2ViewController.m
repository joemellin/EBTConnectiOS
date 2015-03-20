//
//  Tool2S2ViewController.m
//  EBT
//
//  Created by ross chen on 8/14/13.
//  Copyright (c) 2013 ross chen. All rights reserved.
//

#import "Tool2S2ViewController.h"
#import "CheckMarkButton.h"

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
    
    CheckMarkButton* button = [CheckMarkButton buttonWithType:UIButtonTypeCustom];
    button.tag = [indexPath row] * 10 + 0;
    button.frame = CGRectMake(kScreenBounds.size.width/2 - 100 -20, 9, 100, 15);
    [button setupButtonWithTitle:self.displayList[[indexPath row] * 2 + 0]];
    [button addTarget:self action:@selector(checkState:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    button = [CheckMarkButton buttonWithType:UIButtonTypeCustom];
    button.tag = [indexPath row] * 10 + 1;
    button.frame = CGRectMake(kScreenBounds.size.width/2 + 20, 9, 100, 15);
    [button setupButtonWithTitle:self.displayList[[indexPath row] * 2 + 1]];
    [button addTarget:self action:@selector(checkState:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
	   
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   	
}

-(void)checkState:(UIButton*)button{
    
    int row = button.tag / 10;
    int col = button.tag % 10;
    int index = row*2 + col;
    NSString* value = self.displayList[index];
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
