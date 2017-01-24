//
//  HYIndexDBManager.m
//  GSGoldenSea
//
//  Created by frank weng on 17/1/24.
//  Copyright © 2017年 frank weng. All rights reserved.
//

#import "HYIndexDBManager.h"

@implementation HYIndexDBManager

SINGLETON_GENERATOR(HYIndexDBManager, defaultManager)

-(id)init
{
    if(self = [super init]){
    }
    
    return self;
}

-(NSString*)defaultDBPath
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* stkdbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSIndexDayDB.db",[paths stringByDeletingLastPathComponent]];
    
    return stkdbdir;
}

@end
