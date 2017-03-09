//
//  HYStatSTKDBManager.m
//  GSGoldenSea
//
//  Created by frank weng on 17/2/24.
//  Copyright © 2017年 frank weng. All rights reserved.
//

#import "HYStatSTKDBManager.h"

@implementation HYStatSTKDBManager

SINGLETON_GENERATOR(HYStatSTKDBManager, defaultManager)


-(NSString*)defaultDBPath
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* stkdbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSStatSTKDB.db",[paths stringByDeletingLastPathComponent]];
    
    return stkdbdir;
}


- (void)setupDB:(NSString*)dbPath isReset:(BOOL)isReset;
{
    
    [super setupDB:dbPath isReset:isReset];
    
    self.allSTK = [[TStatSTK alloc]init];
    [self.allSTK setup:self.DBHelper];
    if([self.allSTK createTableWithName:@"tAllSTK"]){
        //        DDLogInfo(@"STK table create success!");
    }else{
        DDLogInfo(@"STK table create failed!");
    }
    
    
//    self.querySTK = [[TSTK alloc]init];
//    [self.querySTK setup:self.DBHelper];
//    if([self.querySTK createTableWithName:@"tQuerySTK"]){
//        //        DDLogInfo(@"STK table create success!");
//    }else{
//        DDLogInfo(@"STK table create failed!");
//    }
}

@end
