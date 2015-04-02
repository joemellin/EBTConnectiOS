//
//  ConnectionsCell.h
//  EBT
//
//  Created by Adi on 3/27/15.
//  Copyright (c) 2015 Adrian Coroian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesCell : UITableViewCell
-(void) initCell;
-(void) fillCell:(NSDictionary*) item forRow:(int) row;
@end
