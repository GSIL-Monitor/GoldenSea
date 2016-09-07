//
//  KDataService.m
//  GSGoldenSea
//
//  Created by frank weng on 16/3/2.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "TKData.h"
#import "KDataModel.h"

@implementation TKData

//SINGLETON_GENERATOR(KDataDBService, shareInstance);


-(id)init
{
    self = [super init];
    if(self){
    }
    
    return self;
}



- (BOOL)createTableWithName:(NSString*)tableName
{
    self.modelClassString = NSStringFromClass([KDataModel class]);
    self.tableName =  tableName; 
    
    
    NSArray* paramArray = @[@{@"time"         : @"integer primary key"},
                            @{@"volume"       : @"integer"},
                            @{@"tdIndex"       : @"integer"},
                            
                            @{@"open"         : @"float"},
                            @{@"high"         : @"float"},
                            @{@"close"        : @"float"},
                            @{@"low"          : @"float"},
                            
                            @{@"ma5"          : @"float"},
                            @{@"ma10"         : @"float"},
                            @{@"ma20"         : @"float"},
                            @{@"ma30"         : @"float"},
                            @{@"ma60"         : @"float"},
                            @{@"ma120"         : @"float"},
                            
//                            @{@"ma5"          : @"float"},
//                            @{@"ma10"         : @"float"},
//                            @{@"ma20"         : @"float"},
                            @{@"slopema30"         : @"float"},
                            
                            
                            @{@"isLimitUp"          :@"bool"},
                            @{@"isLimitDown"          :@"bool"}
                            
                            //                            @"chg"          : @"float",
                            //                            @"percent"      : @"float",
                            //                            @"turnrate"     : @"float",
                            //
                            //                            @"dif"          : @"float",
                            //                            @"dea"          : @"float",
                            //                            @"macd"         : @"float"
                            
                            ];
    
    
    self.createIndexString = [NSString stringWithFormat: @"create index if not exists index_time_%@ on %@(time)",tableName,tableName];
    
    return [super createTable:paramArray];
}




#pragma mark - self
- (NSArray *)getRecords:(long)startTime end:(long)endTime;
{
    NSString* sql = [NSString stringWithFormat:@"where time>%ld and  time<=%ld ",startTime, endTime];
    return [super getAllRecordsWithAditonCondition:sql];
}


-(BOOL)deleteRecordWithID:(NSString *)recordID
{
    NSString* condition = [NSString stringWithFormat:@"kdataID = '%@'",recordID];
    
    return [self deleteRecordWithAddtionConditon:condition];
}



@end
