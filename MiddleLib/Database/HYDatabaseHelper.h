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

#define CONVERSATION_TABLE @"conversationTable"
#define MESSAGE_TABLE      @"messageTable"
#define GROUP_TABLE        @"groupTable"
#define GROUPINVITE_TABLE  @"groupInviteTable"
#define GROUPMEMBER_TABLE  @"groupMamberTable"
#define FRIEND_TABLE       @"friendTable"

#define DB_INPUT_NIL    -1

/**
 *  Tele模块数据库表
 */
#define TeleHistory_Table @"teleHistoryTable"
#define NewTeleHistory_Table @"newTeleHistoryTable"

@protocol DatabaseHelperDelegate <NSObject>

//创建数据库表
- (BOOL)creatTableWithTable:(NSString *)table Param:(NSDictionary *)param;

@end

@interface HYDatabaseHelper : NSObject <DatabaseHelperDelegate>

// 用于数据操作的管理队列
@property (nonatomic, strong) HYFMDatabaseQueue *databaseQueue;
// 用于获取数据的数据库
@property (nonatomic, strong) HYFMDatabase *database;

+ (HYDatabaseHelper *)defaultHelper;

- (BOOL)setupDB;
- (BOOL)closeDB;

/**
 *  根据表的名字和参数创建表
 *
 *  @param tbName  表的名字
 *  @param dbParam 表的“字段”和“属性”组成的字典，都是NSString类型
 *
 *  @return 是否创建成功
 */
- (BOOL)creatTableWithTable:(NSString *)table Param:(NSDictionary *)param;


- (BOOL)exeQuery:(NSString *)sql;

@end
