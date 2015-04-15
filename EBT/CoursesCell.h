//
//  CoursesCell.h
//  EBT
//
//  Created by Adrian Coroian on 4/14/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoursesCell : UITableViewCell
-(void) initCell;
-(void) fillCell:(NSDictionary*) item forRow:(int) row;
@end
