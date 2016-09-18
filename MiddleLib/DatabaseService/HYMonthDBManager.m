//
//  HYMonthDBManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/9/18.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYMonthDBManager.h"

@implementation HYMonthDBManager

SINGLETON_GENERATOR(HYMonthDBManager, defaultManager)


-(NSString*)defaultDBPath
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* stkdbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSMonthDB.db",[paths stringByDeletingLastPathComponent]];
    
    return stkdbdir;
}


@end
