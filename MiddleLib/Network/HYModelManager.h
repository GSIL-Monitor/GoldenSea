//
//  HYModelManager.h
//  iRCS
//
//  Created by frank weng on 15/8/27.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYModelManager : NSObject

+ (HYModelManager *)sharedInstance;

- (void) registerJsonKey:(NSArray*)jsonKey withModel:(NSString*)modelClassString;
- (NSArray*)jsonKeyWtihModel:(NSString*)modelClassString;

- (void) registerJsonKeyMap:(NSArray*)jsonKey withModel:(NSString*)modelClassString;
- (NSDictionary*)jsonKeyMapWtihModel:(NSString*)modelClassString;


@end
