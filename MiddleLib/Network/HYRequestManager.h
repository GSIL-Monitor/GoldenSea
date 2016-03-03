//
//  HYRequestManager.h
//  iRCS
//
//  Created by frank weng on 15/8/12.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBaseResponse.h"

@interface HYRequestManager : NSObject

+ (HYRequestManager *)sharedInstance;


- (void) initService;

+ (void) registerRequest:(NSString*)requestClassString withResponse:(NSString*)responseClassString;
+ (HYBaseResponse*) responseWithRequst:(NSString*)requestClassString;

+ (void) registerRequest:(NSString*)requestClassString withModel:(NSString*)modelClassString;
+ (NSString*) modelWithRequst:(NSString *)requestClassString;

@end
