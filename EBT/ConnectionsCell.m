//
//  ConnectionsCell.m
//  EBT
//
//  Created by Adi on 3/27/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "ConnectionsCell.h"
#import <UIImageView+AFNetworking.h>

@interface ConnectionsCell () {
    id _delegate;
    UIButton *_call;
    UIButton *_message;
    UIImageView *_image;
}

@end

@implementation ConnectionsCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id) initWithDelegate:(id) delegate {
    _delegate = delegate;
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConnectionsCell"];
}

-(void) initCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _message = [UIButton buttonWithType:UIButtonTypeCustom];
    _call = [UIButton buttonWithType:UIButtonTypeCustom];
    [_message setImage:[UIImage imageNamed:@"conversation"] forState:UIControlStateNormal];
    [_call setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    
    _call.frame = CGRectMake(kScreenBounds.size.width - 60, 21, 45, 35);
    _message.frame = CGRectMake(_call.frame.origin.x - 60, 21, 45, 35);

    [_call addTarget:_delegate action:@selector(callSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_message addTarget:_delegate action:@selector(messageSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_message];
    [self addSubview:_call];
    
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 68, 68)];
    _image.layer.cornerRadius = 34;
    [_image setClipsToBounds:YES];
    [self addSubview:_image];
    
    [self setIndentationWidth:40];
    self.textLabel.font = [UIFont systemFontOfSize:17];
    self.textLabel.textColor = [UIColor blackColor];
}

-(void) fillCell:(NSDictionary*) item forRow:(int) row {
    _call.tag = row;
    _message.tag = row;
    self.textLabel.text = item[kName];
    [_image setImageWithURL:[NSURL URLWithString:item[kImageURL]] placeholderImage:[UIImage imageNamed:@"avatar_medium"]];
    
    if([item[@"new_message_count"] intValue] == 0) {
        [_message setImage:[UIImage imageNamed:@"conversation"] forState:UIControlStateNormal];
    } else {
        [_message setImage:[UIImage imageNamed:@"conversation_new"] forState:UIControlStateNormal];
    }
}


@end
