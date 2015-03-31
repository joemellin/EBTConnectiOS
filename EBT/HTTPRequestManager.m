//
//  HTTPRequestManager.m
//  Vapor
//
//  Created by Sourabh B. on 15/04/14.
//  Copyright (c) 2014 Addval Solutions. All rights reserved.
//

#import "HTTPRequestManager.h"

@implementation HTTPRequestManager

- (id)init {
    self.httpOperation = [HTTPRequestManager sharedOperationsManager];
    
    self.httpOperation.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.httpOperation.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.httpOperation.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return self;
}

+(AFHTTPRequestOperationManager *)sharedOperationsManager {
    static dispatch_once_t once;
    static AFHTTPRequestOperationManager *sharedManager;
    dispatch_once(&once, ^ {
        sharedManager = [AFHTTPRequestOperationManager manager];
        
        // SSL pinning
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        sharedManager.securityPolicy = securityPolicy;
    });
    return sharedManager;
}
@end
