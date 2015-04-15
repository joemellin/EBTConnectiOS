//
//  ConnectionsCell.m
//  EBT
//
//  Created by Adi on 3/27/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "ProviderCell.h"
#import <UIImageView+AFNetworking.h>

@interface ProviderCell () {
    id _delegate;
    UIButton *_message;
    UIImageView *_image;
    UILabel *_text;
}

@end

@implementation ProviderCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(id) initWithDelegate:(id) delegate {
    _delegate = delegate;
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProviderCell"];
}

-(void) initCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _message = [UIButton buttonWithType:UIButtonTypeCustom];
    [_message setImage:[UIImage imageNamed:@"conversation"] forState:UIControlStateNormal];
    _message.frame = CGRectMake(kScreenBounds.size.width - 60, 21, 45, 35);
    
    [_message addTarget:_delegate action:@selector(messageSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_message];
    
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 68, 68)];
    _image.layer.cornerRadius = 34;
    [_image setClipsToBounds:YES];
    [self addSubview:_image];
    
    
    _text = [[UILabel alloc] init];
    _text.font = [UIFont boldSystemFontOfSize:21];
    _text.textColor = [UIColor blackColor];
    _text.frame = CGRectMake(90, 20, kScreenBounds.size.width - 120, 20);
    [self addSubview:_text];
    
    UILabel *description = [[UILabel alloc] init];
    description.font = [UIFont systemFontOfSize:17];
    description.textColor = kDarkGrayTextColor;
    description.text = @"EBT Provider";
    description.frame = CGRectMake(90, 40, kScreenBounds.size.width - 120, 38);
    [self addSubview:description];
}

-(void) fillCell:(NSDictionary*) item forRow:(int) row {
    _message.tag = row;
    _text.text = item[kName];
    [_image setImageWithURL:[NSURL URLWithString:item[kImageURL]] placeholderImage:[UIImage imageNamed:@"avatar_medium"]];
    
    if([item[@"new_message_count"] intValue] == 0) {
        [_message setImage:[UIImage imageNamed:@"conversation"] forState:UIControlStateNormal];
    } else {
        [_message setImage:[UIImage imageNamed:@"conversation_new"] forState:UIControlStateNormal];
    }
}


@end
