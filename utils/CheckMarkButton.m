//
//  CheckMarkButton.m
//  EBT
//
//  Created by Adi on 3/19/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import "CheckMarkButton.h"

@implementation CheckMarkButton
-(void)setupButtonWithTitle:(NSString *)title {
    
    UIImage *checkedImage = [[UIImage imageNamed:@"checked"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    UIImage *uncheckedImage = [[UIImage imageNamed:@"unchecked"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
   
    [self setBackgroundImage:uncheckedImage forState:UIControlStateNormal];
    [self setBackgroundImage:checkedImage forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 31, 0, 0)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
