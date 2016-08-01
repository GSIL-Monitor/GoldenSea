//
//  STKDBService.m
//  GSGoldenSea
//
//  Created by frank weng on 16/3/4.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "STKDBService.h"
#import "STKModel.h"

@implementation STKDBService

SINGLETON_GENERATOR(STKDBService, shareManager)


-(id)init
{
    self = [super init];
    if(self){
    }
    
    return self;
}



- (BOOL)createTableWithName:(NSString*)tableName
{
    self.modelClassString = NSStringFromClass([STKModel class]);
    self.tableName =  tableName; // @"Table_kData";
    
    NSDictionary *param = @{                            
                            @"stkID"                    : @"text primary key",
//                            @"type"                      : @"integer",
//                            @"relatedRecordID"   : @"text",
//                            @"createdTimeStamp"       : @"integer"
                            
      
                            };
    
    
    
    //test.
//    self.createIndexString = [NSString stringWithFormat: @"create index index_time on %@(stkID)",tableName];

    
    return [super createTable:param];
}



@end
