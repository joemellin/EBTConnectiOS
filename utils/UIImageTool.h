//
//  UIImageTool.h
//  PhotoApp
//
//  Created by iphone on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Extras)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)imageByScalingToSize:(CGSize)newSize;
-(UIImage*)imageByCroppingWithRect:(CGRect)rect;
- (UIImage*)imageByScalingForSize:(CGSize)targetSize;
@end
