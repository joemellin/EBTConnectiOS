//
//  CoursesCell.m
//  EBT
//
//  Created by Adrian Coroian on 4/14/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "CoursesCell.h"
#import <UIImageView+AFNetworking.h>

@interface CoursesCell () {
    UILabel *_title;
    UIImageView *_imageView;
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
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 88, 88)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    
    _title = [[UILabel alloc] init];
    _title.numberOfLines = 3;
    _title.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:_title];
}

-(void) fillCell:(NSDictionary *)item forRow:(int) row {
    _title.text = item[kName];
    float height = [Utils heightWithText:_title.text andFont:_title.font andMaxWidth:kScreenBounds.size.width - 108 andMaxHeight:80];
    _title.frame = CGRectMake(98, 88/2 - height/2, kScreenBounds.size.width - 108, height);
    [_imageView setImageWithURL:[NSURL URLWithString:item[@"thumbnail_url"]]];
}

@end
