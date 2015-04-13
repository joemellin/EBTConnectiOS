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
    UIImageView *_newMessage;
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
    _text.frame = CGRectMake(90, 10, kScreenBounds.size.width - 120, 20);
    [self addSubview:_text];
    
    _detailText = [[UILabel alloc] init];
    _detailText.numberOfLines = 2;
    _detailText.font = [UIFont systemFontOfSize:17];
    _detailText.frame = CGRectMake(90, 40, kScreenBounds.size.width - 120, 38);
    [self addSubview:_detailText];
    
    _newMessage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newMessage"]];
    _newMessage.frame = CGRectMake(kScreenBounds.size.width - _newMessage.frame.size.width-5,
                                   44-_newMessage.frame.size.height/2,
                                   _newMessage.frame.size.width, _newMessage.frame.size.height);
    [self addSubview:_newMessage];
}

-(void) fillCell:(NSDictionary*) item forRow:(int) row {
    _text.text = item[kSender][kFname];
    _detailText.text = item[kContent];
    float height = [Utils heightWithText:item[kContent] andFont:_detailText.font andMaxWidth:_detailText.frame.size.width];
    float top = (self.frame.size.height - height - 25)/2;
    _text.frame = CGRectMake(_text.frame.origin.x, top, _text.frame.size.width, _text.frame.size.height);
    _detailText.frame = CGRectMake(_detailText.frame.origin.x, top+25, kScreenBounds.size.width-100, height);
    
    [_image setImageWithURL:[NSURL URLWithString:item[kSender][kImageURL]] placeholderImage:[UIImage imageNamed:@"avatar_medium"]];
    
    if(item[kRead]) {
        _detailText.textColor = klightGrayTextColor;
        _newMessage.hidden = YES;
    } else {
        _newMessage.hidden = NO;
        _detailText.textColor = kDarkGrayMessaging;
    }
}


@end
