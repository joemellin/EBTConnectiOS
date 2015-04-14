//
//  GroupCellTableViewCell.m
//  EBT
//
//  Created by Adrian Coroian on 4/10/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "GroupCellTableViewCell.h"
#import "HTTPRequestManager.h"

@interface GroupCellTableViewCell () {
    id _delegate;
}

@end

@implementation GroupCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id) initWithDelegate:(id) delegate {
    _delegate = delegate;
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"groupIcon"]];
    imageView.frame = CGRectMake(10, 10, 68, 68);
    [self addSubview:imageView];
    
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont boldSystemFontOfSize:21];
    title.textColor = [UIColor blackColor];
    title.text = @"My Group";
    title.frame = CGRectMake(90, 20, kScreenBounds.size.width - 120, 20);
    [self addSubview:title];
    
    UILabel *description = [[UILabel alloc] init];
    description.font = [UIFont systemFontOfSize:17];
    description.textColor = [UIColor blackColor];
    description.text = @"Conference line";
    description.frame = CGRectMake(90, 40, kScreenBounds.size.width - 120, 38);
    [self addSubview:description];
    
    UIButton *conferenceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [conferenceButton setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    conferenceButton.frame = CGRectMake(kScreenBounds.size.width-55, 25, 45, 35);
    [conferenceButton addTarget:_delegate action:@selector(conferenceCall) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:conferenceButton];
}

@end
