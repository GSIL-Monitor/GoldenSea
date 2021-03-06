//
//  QueryResDBService.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/19.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "TQueryRes.h"
#import "QueryResModel.h"

@implementation TQueryRes



- (BOOL)createTableWithName:(NSString*)tableName
{
    self.modelClassString = NSStringFromClass([QueryResModel class]);
    self.tableName =  tableName;
    
    
    NSArray* paramArray = @[@{@"stkID"        : @"text primary key",},
                            @{@"time"         : @"integer"},
                            @{@"pvLast2kTP1DataMA5"         : @"float"},
                            @{@"buyVal"         : @"float"}
//                            @{@"tIndex"       : @"integer"}
                            
//                            @{@"open"         : @"float"},
//                            @{@"high"         : @"float"},
//                            @{@"close"        : @"float"},
//                            @{@"low"          : @"float"},
//                            
//                            @{@"ma5"          : @"float"},
//                            @{@"ma10"         : @"float"},
//                            @{@"ma20"         : @"float"},
//                            @{@"ma30"         : @"float"},
//                            
//                            @{@"isLimitUp"          :@"bool"},
//                            @{@"isLimitDown"          :@"bool"}
                            
                            ];
    
    
    self.createIndexString = [NSString stringWithFormat: @"create index if not exists index_time_%@ on %@(time)",tableName,tableName];
    
    return [super createTable:paramArray];
}


@end
