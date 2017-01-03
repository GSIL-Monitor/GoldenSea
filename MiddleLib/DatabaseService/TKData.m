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
                            
                            @{@"open"         : @"float"},
                            @{@"high"         : @"float"},
                            @{@"close"        : @"float"},
                            @{@"low"          : @"float"},
                            
                            @{@"volume"       : @"float"},

                            @{@"isLimitUp"          :@"bool"},
                            @{@"isLimitDown"          :@"bool"},
                            
                            @{@"ma5"          : @"float"},
                            @{@"ma10"         : @"float"},
                            @{@"ma20"         : @"float"},
                            @{@"ma30"         : @"float"},
                            @{@"ma60"         : @"float"},
                            @{@"ma120"         : @"float"},
                     
                            
//                            @{@"macd"         : @"float"},
//                            @{@"macdbar"         : @"float"},
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

- (NSArray *)getWeekRecords:(long)startTime end:(long)endTime;
{
    NSString* sql = [NSString stringWithFormat:@"where time>%ld and  time<=%ld ",startTime, endTime];
    return [super getAllRecordsWithAditonCondition:sql];
}


- (NSArray *)getMonthRecords:(long)startTime end:(long)endTime;
{
    NSString* sql = [NSString stringWithFormat:@"where time>%ld and  time<=%ld ",startTime, endTime];
    return [super getAllRecordsWithAditonCondition:sql];
}



-(BOOL)deleteRecordWithTime:(long)time;
{
    NSString* condition = [NSString stringWithFormat:@"time = %ld",time];
    
    return [self deleteRecordWithAddtionConditon:condition];
}

-(BOOL)updateRecord:(KDataModel *)recordModel
{
    NSString* condition = [NSString stringWithFormat:@"time = %ld",recordModel.time];

    return [self updateRecord:recordModel WithAditonCondition:condition];
}


@end
