//
//  HYWeekDBManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/9/18.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYWeekDBManager.h"

@implementation HYWeekDBManager

SINGLETON_GENERATOR(HYWeekDBManager, defaultManager)


-(NSString*)defaultDBPath
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* stkdbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSWeekDB.db",[paths stringByDeletingLastPathComponent]];
    
    return stkdbdir;
}

@end
