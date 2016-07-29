//
//  HYDatabaseHelper.m
//  iRCS
//
//  Created by 王斌 on 15/8/31.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import "HYDatabaseHelper.h"
#import "HYFMDatabase.h"

@implementation HYDatabaseHelper

static HYDatabaseHelper *defaultHelper = nil;


//获取默认的静态的局部类
SINGLETON_GENERATOR(HYDatabaseHelper, defaultHelper)

- (instancetype)init
{
    self = [super init];
    return self;
}

- (BOOL)setupDB
{
    __block BOOL rst = NO;
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *dbPath = [paths stringByAppendingPathComponent:@"GSStkDB.db"];

    
    DDLogInfo(@"dbpath========%@",dbPath);
    self.databaseQueue = [HYFMDatabaseQueue databaseQueueWithPath:dbPath];
    [self.databaseQueue inDatabase:^(HYFMDatabase *db) {
        
        self.database = db;
        if ([db open])
        {
            rst = YES;
            DDLogInfo(@"数据库创建成功");
        }else
        {
            rst = NO;
            DDLogInfo(@"数据库创建失败！");
        }
    }];
    return rst;
}

- (BOOL)closeDB
{
    BOOL rst = [self.database close];
    self.database = nil;
    self.databaseQueue = nil;
    return rst;
}

- (BOOL)creatTableWithTable:(NSString *)table Param:(NSDictionary *)param
{
    __block BOOL ret = NO;
    [self.databaseQueue inDatabase:^(HYFMDatabase *db) {
        NSMutableString *strParam = nil;
        NSArray *keys = [param allKeys];
        for (NSString *key in keys) {
            NSString *obj = [param objectForKey:key];
            
            if (!strParam) {
                strParam = [[NSString stringWithFormat:@"%@ %@",key,obj]mutableCopy];
            }else{
                [strParam appendString:[NSString stringWithFormat:@",%@ %@",key,obj]];
            }
        }
        
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@  (%@)",table,strParam];
        ret = [db executeUpdate:sql];
        
    }];
    return ret;
}


@end
