//
//  HYLog.h
//  iRCS
//
//  Created by frank weng on 15/11/12.
//  Copyright © 2015年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYLog : NSObject

+(HYLog*)shareManager;


- (void) initLog;
+ (void) logObject:(NSObject*)obj;
- (BOOL) logToFile:(NSString*)msg;


@end
