//
//  HYSTKDBManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/10/18.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYSTKDBManager.h"

@implementation HYSTKDBManager

SINGLETON_GENERATOR(HYSTKDBManager, defaultManager)


-(NSString*)defaultDBPath
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* stkdbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSSTKDB.db",[paths stringByDeletingLastPathComponent]];
    
    return stkdbdir;
}


@end
