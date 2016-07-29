//
//  HYBaseDBService.h
//  iRCS
//
//  Created by frank weng on 15/10/8.
//  Copyright © 2015年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBaseModel.h"

typedef enum {
    dbType_string = 0,
    dbType_int,
    dbType_long,
    dbType_longlong,
    dbType_bool,
    dbType_float,
    dbType_double,
    dbType_date,    //nsdate
    dbType_data,    //nsdata
    dbType_obj,     //nsobject
}dbType;


@interface HYBaseDBService : NSObject

@property (nonatomic,strong) NSString* tableName;
@property (nonatomic,strong) NSDictionary* keyTypeDict; //key:db key, value: db type
@property (nonatomic,strong) NSString* modelClassString;
@property (nonatomic,strong) NSString* createIndexString;

- (void)setup;

/**
 *  create the table in db
 *
 *  @return success or not
 */
- (BOOL)createTable;
- (BOOL)createTableWithName:(NSString*)tableName;

- (BOOL)createTable:(NSDictionary*)param;
- (BOOL)createTableByArray:(NSArray*)param;


/**
 *  get the record number of this table.
 *
 *  @return number.
 */
- (long long)getRecordNumber;


/**
 *  get all records
 *
 *  @return records
 */
- (NSArray *)getAllRecords;

/**
 *  add one record to db
 *
 *  @param recordModel
 *
 *  @return sccuss or not
 */
- (BOOL)addRecord:(HYBaseModel *) recordModel;


/**
 *  update one exist record in db
 *
 *  @param recordModel
 *
 *  @return sccuss or not
 */
- (BOOL)updateRecord:(HYBaseModel *)recordModel;


/**
 *  delete one record in db
 *
 *  @param record id
 *
 *  @return sccuss or not
 */
- (BOOL)deleteRecordWithID:(NSString *) recordID;


/**
 *  delete all record in db
 *
 *  @return sccuss or not
 */
- (BOOL)deleteAllRecords;






#pragma mark - child class used fucntions

/**
 *  get record with addtional condition, for child class use.
 */
- (NSArray *)getAllRecordsWithAditonCondition:(NSString*)condition;

/**
 *  delete record with addtional condition, for child class use.
 */
- (BOOL)deleteRecordWithAddtionConditon:(NSString *) condition;

/**
 *  update record with addtional condition, for child class use.
 */
- (BOOL)updateRecord:(HYBaseModel *)recordModel WithAditonCondition:(NSString *)condition;


@end
