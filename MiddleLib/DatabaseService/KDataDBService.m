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

//SINGLETON_GENERATOR(KDataDBService, shareManager);


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
    self.tableName =  tableName; // @"Table_kData";
    
//    NSDictionary *param = @{
//                            @"time"         : @"integer primary key",
//                            @"volume"       : @"integer",
//                            
//                            @"open"         : @"float",
//                            @"high"         : @"float",
//                            @"close"        : @"float",
//                            @"low"          : @"float",
//                            
//                            @"ma5"          : @"float",
//                            @"ma10"         : @"float",
//                            @"ma20"         : @"float",
//                            @"ma30"         : @"float",
//                            
//                            @"isLimitUp"          :@"bool",
//                            @"isLimitDown"          :@"bool",
//                            
////                            @"chg"          : @"float",
////                            @"percent"      : @"float",
////                            @"turnrate"     : @"float",
////                            
////                            @"dif"          : @"float",
////                            @"dea"          : @"float",
////                            @"macd"         : @"float"
//                            };
    
    NSArray* paramArray = @[@{@"time"         : @"integer primary key"},
                            @{@"volume"       : @"integer"},
                            
                            @{@"open"         : @"float"},
                            @{@"high"         : @"float"},
                            @{@"close"        : @"float"},
                            @{@"low"          : @"float"},
                            
                            @{@"ma5"          : @"float"},
                            @{@"ma10"         : @"float"},
                            @{@"ma20"         : @"float"},
                            @{@"ma30"         : @"float"},
                            
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
    
    
    self.createIndexString = [NSString stringWithFormat: @"create index index_time on %@(time)",tableName];
    
    return [super createTable:paramArray];
}




#pragma mark - Del
-(BOOL)deleteRecordWithID:(NSString *)recordID
{
    NSString* condition = [NSString stringWithFormat:@"kdataID = '%@'",recordID];
    
    return [self deleteRecordWithAddtionConditon:condition];
}



@end
