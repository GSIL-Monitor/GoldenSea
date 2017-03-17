//
//  TStatSTK.m
//  GSGoldenSea
//
//  Created by frank weng on 17/2/24.
//  Copyright © 2017年 frank weng. All rights reserved.
//

#import "TStatSTK.h"
#import "StatSTKModel.h"

@implementation TStatSTK

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

//@property (nonatomic, assign) CGFloat lastClose;
//@property (nonatomic, assign) CGFloat DVValue5D; //倒计
//@property (nonatomic, assign) CGFloat DVValue20D;
//@property (nonatomic, assign) CGFloat DVValuePoint1; //one day - another day
//@property (nonatomic, assign) CGFloat DVValuePoint2; //one day - another day

- (BOOL)createTableWithName:(NSString*)tableName
{
    self.modelClassString = NSStringFromClass([STKModel class]);
    self.tableName =  tableName; // @"Table_kData";
    
    NSArray *param = @[@{@"stkID"                    : @"text primary key"},
                       
                       @{@"name"                    : @"text"},
                       @{@"industry"                    : @"text"},
                       @{@"province"                    : @"text"},
                       @{@"property"                    : @"text"},
                       
                       @{@"totalMV"         : @"float"},
                       @{@"curMV"         : @"float"},
                       
                       @{@"lastClose"         : @"float"},
                       @{@"DVValue5D"         : @"float"},
                       @{@"DVValue20D"         : @"float"},
                       @{@"DVValuePoint1"         : @"float"},
                       @{@"DVValuePoint2"         : @"float"},
                       
                       //                            @"createdTimeStamp"       : @"integer"
                       
                       ];
    
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

- (NSArray *)getRecordsWithIndustry:(NSString*)keyWord;
{
    //ref http://www.cnblogs.com/wendingding/p/3871577.html
    NSString* sql = [NSString stringWithFormat:@"where industry like '%%%@%%' ",keyWord];
    NSArray* res = [super getAllRecordsWithAditonCondition:sql];
    
    return res;
}

-(BOOL)updateTime:(long)updateTime WithID:(NSString *)recordID
{
    
    STKModel* model = [self getRecordWithID:recordID];
    if(!model){
        model = [[STKModel alloc]init];
    }
    
    model.stkID = recordID;
//    model.lastUpdateTime = updateTime;
    
    NSString* condition = [NSString stringWithFormat:@"stkID = '%@'",recordID];
    
    return [self updateRecord:model WithAditonCondition:condition];
}

@end
