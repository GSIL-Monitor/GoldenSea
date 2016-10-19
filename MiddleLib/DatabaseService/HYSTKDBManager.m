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



- (void)setupDB:(NSString*)dbPath isReset:(BOOL)isReset;
{
    
    [super setupDB:dbPath isReset:isReset];
    
    self.allSTK = [[TSTK alloc]init];
    [self.allSTK setup:self.DBHelper];
    if([self.allSTK createTableWithName:@"tAllSTK"]){
        //        DDLogInfo(@"STK table create success!");
    }else{
        DDLogInfo(@"STK table create failed!");
    }
    
    
    self.querySTK = [[TSTK alloc]init];
    [self.querySTK setup:self.DBHelper];
    if([self.querySTK createTableWithName:@"tQuerySTK"]){
        //        DDLogInfo(@"STK table create success!");
    }else{
        DDLogInfo(@"STK table create failed!");
    }
}

@end
