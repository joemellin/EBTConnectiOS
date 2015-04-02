//
//  ConnectionsCell.m
//  EBT
//
//  Created by Adi on 3/27/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "MessagesCell.h"
#import <UIImageView+AFNetworking.h>

@interface MessagesCell () {
    id _delegate;
    UILabel *_detailText;
    UIImageView *_image;
    UILabel *_text;
}

@end

@implementation MessagesCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 68, 68)];
    _image.layer.cornerRadius = 34;
    [_image setClipsToBounds:YES];
    [self addSubview:_image];
    
    
    _text = [[UILabel alloc] init];
    _text.font = [UIFont boldSystemFontOfSize:21];
    _text.textColor = [UIColor blackColor];
    _text.frame = CGRectMake(90, 10, kScreenBounds.size.width - 100, 40);
    [self addSubview:_text];
    
    _detailText = [[UILabel alloc] init];
    _detailText.font = [UIFont systemFontOfSize:17];
    _detailText.textColor = [UIColor blackColor];
    _detailText.frame = CGRectMake(90, 40, kScreenBounds.size.width - 100, 38);
    [self addSubview:_detailText];
}

-(void) fillCell:(NSDictionary*) item forRow:(int) row {
    _text.text = item[kSender][kFname];
    _detailText.text = item[kContent];
    [_image setImageWithURL:[NSURL URLWithString:item[kSender][kImageURL]] placeholderImage:[UIImage imageNamed:@"avatar_medium"]];
    
    
}


@end
