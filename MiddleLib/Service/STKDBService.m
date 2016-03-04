//
//  STKDBService.m
//  GSGoldenSea
//
//  Created by frank weng on 16/3/4.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "STKDBService.h"

@implementation STKDBService

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
//    self.modelClassString = NSStringFromClass([KDataModel class]);
    self.tableName =  tableName; // @"Table_kData";
    
    NSDictionary *param = @{
                            @"kSTKID"                    : [NSNumber numberWithInt:((1 << 8) + dbType_int)],
                            
                            
                            
      
                            };
    
    self.keyTypeDict = param;
    
    return [super createTable:tableName];
}



@end
