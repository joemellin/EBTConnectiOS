//
//  HTTPRequestManager.h
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HTTPRequestManager : AFHTTPRequestOperationManager

@property(nonatomic,strong)AFHTTPRequestOperationManager *httpOperation;

@end
