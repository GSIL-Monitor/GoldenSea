//
//  HYDatabaseHelper.h
//  iRCS
//
//  Created by 王斌 on 15/8/31.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYFMDatabase.h"
#import "HYFMDatabaseQueue.h"

#define DB_INPUT_NIL    -1



@protocol DatabaseHelperDelegate <NSObject>

//创建数据库表
- (BOOL)creatTableWithTable:(NSString *)table DictParam:(NSDictionary *)param;

@end

@interface HYDatabaseHelper : NSObject <DatabaseHelperDelegate>

// 用于数据操作的管理队列
@property (nonatomic, strong) HYFMDatabaseQueue *databaseQueue;
// 用于获取数据的数据库
@property (nonatomic, strong) HYFMDatabase *database;

//+ (HYDatabaseHelper *)defaultHelper;

- (BOOL)setupDB:(NSString*)dbPath isReset:(BOOL)isReset;
- (BOOL)closeDB;

/**
 *  根据表的名字和参数创建表
 *
 *  @param tbName  表的名字
 *  @param dbParam 表的“字段”和“属性”组成的字典，都是NSString类型
 *
 *  @return 是否创建成功
 */
- (BOOL)creatTableWithTable:(NSString *)table DictParam:(NSDictionary *)param;
- (BOOL)creatTableWithTable:(NSString *)table ArrayParam:(NSArray *)param;


- (BOOL)exeQuery:(NSString *)sql;

@end
