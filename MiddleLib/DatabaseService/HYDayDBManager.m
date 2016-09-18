//
//  HYDBManager.m
//  HYBaseProject
//
//  Created by frank weng on 16/6/21.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYDayDBManager.h"


@interface HYDayDBManager()

@end

@implementation HYDayDBManager

SINGLETON_GENERATOR(HYDayDBManager, defaultManager)

-(id)init
{
    if(self = [super init]){
    }
    
    return self;
}

-(NSString*)defaultDBPath
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* stkdbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSDayDB.db",[paths stringByDeletingLastPathComponent]];
    
    return stkdbdir;
}




@end
