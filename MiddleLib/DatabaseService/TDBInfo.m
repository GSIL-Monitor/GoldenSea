//
//  TDBInfo.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/26.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "TDBInfo.h"

@implementation DBInfoModel


@end


@implementation TDBInfo

SINGLETON_GENERATOR(TDBInfo, shareInstance)


-(id)init
{
    self = [super init];
    if(self){
    }
    
    return self;
}



- (BOOL)createTableWithName:(NSString*)tableName
{
    self.modelClassString = NSStringFromClass([DBInfoModel class]);
    self.tableName =  tableName; // @"Table_kData";
    
    NSArray *param = @[@{@"version"                    : @"text primary key"},
                       @{@"lastUpdateTime"           : @"integer "},
                       
                       //                            @"type"                      : @"integer",
                       //                            @"relatedRecordID"   : @"text",
                       //                            @"createdTimeStamp"       : @"integer"
                       
                       
                       ];
    
    
    return [super createTable:param];
}


-(DBInfoModel*)getRecord
{
    NSArray* res = [super getAllRecords];
    if(!res || ![res count]){
        return nil;
    }
    
    return [res objectAtIndex:0];
}

-(BOOL)updateTime:(long)updateTime
{
    
    DBInfoModel* model = [self getRecord];
    if(!model){
        model = [[DBInfoModel alloc]init];
        model.version = [NSString stringWithFormat:@"%ld",updateTime]; //first set version
        model.lastUpdateTime = updateTime;

        return [self addRecord:model];
    }
    
    model.lastUpdateTime = updateTime;
    
    
    return [self updateRecord:model];
}


@end
