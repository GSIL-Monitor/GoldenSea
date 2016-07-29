//
//  HYDBManager.h
//  HYBaseProject
//
//  Created by frank weng on 16/6/21.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYDBManager : NSObject

+(HYDBManager *)defaultManager;


- (void)setupDB;
- (BOOL)closeDB;


@end
