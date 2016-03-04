//
//  KDataService.m
//  GSGoldenSea
//
//  Created by frank weng on 16/3/2.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "KDataDBService.h"
#import "KDataModel.h"

@implementation KDataDBService

SINGLETON_GENERATOR(KDataDBService, shareManager);


-(id)init
{
    self = [super init];
    if(self){
        //        [self createTable];
    }
    
    return self;
}



- (BOOL)createTable:(NSString*)tableName
{
    self.modelClassString = NSStringFromClass([KDataModel class]);
    self.tableName =  tableName; // @"Table_kData";
    
    NSDictionary *param = @{
                            @"kdataID"                    : [NSNumber numberWithInt:((1 << 8) + dbType_int)],
                            
                            @"volume"                      : [NSNumber numberWithInt:dbType_int],
                            
                            @"open"   : [NSNumber numberWithInt:dbType_float],
                            @"high"       : [NSNumber numberWithInt:dbType_float],
                            @"close"   : [NSNumber numberWithInt:dbType_float],
                            @"low"       : [NSNumber numberWithInt:dbType_float],
                            
                            @"chg"   : [NSNumber numberWithInt:dbType_float],
                            @"percent"   : [NSNumber numberWithInt:dbType_float],
                            @"turnrate"       : [NSNumber numberWithInt:dbType_float],
                            
                            @"ma5"   : [NSNumber numberWithInt:dbType_float],
                            @"ma10"       : [NSNumber numberWithInt:dbType_float],
                            @"ma20"   : [NSNumber numberWithInt:dbType_float],
                            @"ma30"       : [NSNumber numberWithInt:dbType_float],
                            
                            @"dif"   : [NSNumber numberWithInt:dbType_float],
                            @"dea"       : [NSNumber numberWithInt:dbType_float],
                            @"macd"   : [NSNumber numberWithInt:dbType_float],
                            @"time"       : [NSNumber numberWithInt:dbType_string],
                            };
    
    self.keyTypeDict = param;
    
    return [super createTable:tableName];
}




#pragma mark - Del
-(BOOL)deleteRecordWithID:(NSString *)recordID
{
    NSString* condition = [NSString stringWithFormat:@"kdataID = '%@'",recordID];
    
    return [self deleteRecordWithAddtionConditon:condition];
}



@end
