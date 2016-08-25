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
//SINGLETON_GENERATOR(HYDatabaseHelper, defaultHelper)

- (instancetype)init
{
    self = [super init];
    return self;
}

- (BOOL)setupDB:(NSString*)dbPath isReset:(BOOL)isReset;
{
    __block BOOL rst = NO;
//    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//    
//    NSString *dbPath = [paths stringByAppendingPathComponent:@"GSStkDB.db"];
    
    
    if(isReset){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *err=nil;
        if ([fileManager fileExistsAtPath:dbPath]) {
            [fileManager removeItemAtPath:dbPath error:&err];
            if (err) {
                NSLog(@"Remove old db failed：%@", err);
            }
        }
    }
    
    
    self.databaseQueue = [HYFMDatabaseQueue databaseQueueWithPath:dbPath];
    [self.databaseQueue inDatabase:^(HYFMDatabase *db) {
        
        self.database = db;
        if ([db open])
        {
            rst = YES;
//            DDLogInfo(@"数据库创建成功");
        }else
        {
            rst = NO;
//            DDLogInfo(@"数据库创建失败！");
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

- (BOOL)creatTableWithTable:(NSString *)table DictParam:(NSDictionary *)param
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


- (BOOL)creatTableWithTable:(NSString *)table ArrayParam:(NSArray *)param;
{
    __block BOOL ret = NO;
    [self.databaseQueue inDatabase:^(HYFMDatabase *db) {
        NSMutableString *strParam = nil;
        
        for(NSDictionary* dict in param){
            for(NSString* key in [dict allKeys]){
                NSString* obj = [dict safeValueForKey:key];
                if (!strParam) {
                    strParam = [[NSString stringWithFormat:@"%@ %@",key,obj]mutableCopy];
                }else{
                    [strParam appendString:[NSString stringWithFormat:@",%@ %@",key,obj]];
                }
            }           
        }
        
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@  (%@)",table,strParam];
        ret = [db executeUpdate:sql];
        
    }];
    return ret;
}

- (BOOL)exeQuery:(NSString *)sql;
{
    __block BOOL ret = NO;
    [self.databaseQueue inDatabase:^(HYFMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    return ret;
}


@end
