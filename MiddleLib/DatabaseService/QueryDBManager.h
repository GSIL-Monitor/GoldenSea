//
//  QueryDBManager.h
//  GSGoldenSea
//
//  Created by frank weng on 16/8/19.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQueryRes.h"

@interface QueryDBManager : NSObject

+(QueryDBManager *)defaultManager;

@property (nonatomic, strong) TQueryRes* qREsDBService;


- (void)setupDB:(NSString*)dbPath isReset:(BOOL)isReset;;
- (BOOL)closeDB;


@end
