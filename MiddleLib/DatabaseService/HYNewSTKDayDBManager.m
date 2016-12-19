//
//  HYNewSTKDayDBManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/12/16.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYNewSTKDayDBManager.h"

@implementation HYNewSTKDayDBManager


SINGLETON_GENERATOR(HYNewSTKDayDBManager, defaultManager)

-(id)init
{
    if(self = [super init]){
    }
    
    return self;
}

-(NSString*)defaultDBPath
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* stkdbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSNewSTKDayDB.db",[paths stringByDeletingLastPathComponent]];
    
    return stkdbdir;
}

@end
