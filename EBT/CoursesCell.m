//
//  CoursesCell.m
//  EBT
//
//  Created by Adrian Coroian on 4/14/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "CoursesCell.h"
@interface CoursesCell () {
    UILabel *_title;
}
@end

@implementation CoursesCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initCell {
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 88, 88)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    
    _title = [[UILabel alloc] init];
    _title.numberOfLines = 2;
    _title.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:_title];
}

-(void) fillCell:(NSDictionary *)item {
    _title.text = item[kName];
    float height = [Utils heightWithText:_title.text andFont:_title.font andMaxWidth:kScreenBounds.size.width - 108 andMaxHeight:60];
    _title.frame = CGRectMake(98, 88/2 - height/2, kScreenBounds.size.width - 108, height);
}

@end