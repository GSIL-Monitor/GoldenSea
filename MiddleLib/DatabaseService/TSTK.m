//
//  STKDBService.m
//  GSGoldenSea
//
//  Created by frank weng on 16/3/4.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "TSTK.h"
#import "STKModel.h"

@implementation TSTK



-(id)init
{
    self = [super init];
    if(self){
    }
    
    return self;
}


/*
 @property (nonatomic, strong) NSString* stkID;
 @property (nonatomic, strong) NSString* name;
 @property (nonatomic, strong) NSString* industry;
 @property (nonatomic, strong) NSString* province;
 @property (nonatomic, assign) CGFloat totalMV; //market value;
 @property (nonatomic, assign) CGFloat curMV; //current market value;
 */

- (BOOL)createTableWithName:(NSString*)tableName
{
    self.modelClassString = NSStringFromClass([STKModel class]);
    self.tableName =  tableName; // @"Table_kData";
    
    NSArray *param = @[@{@"stkID"                    : @"text primary key"},
                       
                       @{@"name"                    : @"text"},
                       @{@"industry"                    : @"text"},
                       @{@"province"                    : @"text"},

                       @{@"totalMV"         : @"float"},
                       @{@"curMV"         : @"float"},
                       
//                       @{@"lastUpdateTime"           : @"integer"},

//                            @"type"                      : @"integer",
//                            @"relatedRecordID"   : @"text",
//                            @"createdTimeStamp"       : @"integer"
                            
      
                    ];
    
    
    
    //test.
//    self.createIndexString = [NSString stringWithFormat: @"create index index_time on %@(stkID)",tableName];

    
    return [super createTable:param];
}


-(STKModel*)getRecordWithID:(NSString *)recordID
{
    NSString* sql = [NSString stringWithFormat:@"where stkID = '%@' ",recordID];
    NSArray* res = [super getAllRecordsWithAditonCondition:sql];
    if(!res || ![res count]){
        return nil;
    }
    
    return [res objectAtIndex:0];
}

-(BOOL)updateTime:(long)updateTime WithID:(NSString *)recordID
{
    
    STKModel* model = [self getRecordWithID:recordID];
    if(!model){
        model = [[STKModel alloc]init];
    }
    
    model.stkID = recordID;
    model.lastUpdateTime = updateTime;
    
    NSString* condition = [NSString stringWithFormat:@"stkID = '%@'",recordID];

    return [self updateRecord:model WithAditonCondition:condition];
}


@end
