//
//  HYBaseDBService.m
//  iRCS
//
//  Created by frank weng on 15/10/8.
//  Copyright © 2015年 frank weng. All rights reserved.
//

#import "HYBaseDBService.h"
#import "HYDatabaseHelper.h"


@interface HYBaseDBService ()

@property (nonatomic, strong) HYDatabaseHelper *dbHelper;

@property (nonatomic, strong) HYFMDatabaseQueue *databaseQueue;

@property (nonatomic, strong) HYFMDatabase *database;

@end


@implementation HYBaseDBService


-(id)init
{
    self = [super init];
    if(self){
        [self setup];
    }
    
    return self;
}



- (void)setup
{
    self.dbHelper = [HYDatabaseHelper defaultHelper];
    self.database = self.dbHelper.database;
    self.databaseQueue = self.dbHelper.databaseQueue;
}


#pragma mark - interface functions
-(BOOL)createTable
{
    GSAssert(NO,@"You MUST implement it in child class!");
    
    return NO;
}

- (BOOL)createTableWithName:(NSString*)tableName;
{
    GSAssert(NO,@"You MUST implement it in child class!");
    
    return NO;
}


/**
 *  create table
 *
 *  @return success or not
 */
- (BOOL)createTable:(NSDictionary*)param
{
    NSMutableDictionary* keyType = [NSMutableDictionary dictionary];
    for(NSString* key in [param allKeys]){
        NSString* value = [param safeValueForKey:key];
        [keyType safeSetValue:[NSNumber numberWithInt:[self dbTypeWithValue:value]] forKey:key];
    }
    
    //get keytypedict.
    self.keyTypeDict = keyType;
    
#ifdef DEBUG
    [self isValidKeyToModel];
#endif
    
    return [self.dbHelper creatTableWithTable:self.tableName Param:param];
}



- (NSArray *)getAllRecords
{
    return [self getAllRecordsWithAditonCondition:nil];
}


- (NSArray *)getAllRecordsWithAditonCondition:(NSString *)condition
{
    //GROUP BY contacterName, callDate ORDER BY callTimeStampStart DESC;
    
    __block NSMutableArray *allRecordArray = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(HYFMDatabase *db) {
        NSString *sqlString;
        if (condition) {
            sqlString = [NSString stringWithFormat:@"SELECT %@ FROM %@ %@",[self buildAllFieldKeyString],self.tableName,condition];
        }else{
            sqlString = [NSString stringWithFormat:@"SELECT %@ FROM %@",[self buildAllFieldKeyString],self.tableName];
        }
        
        HYFMResultSet * rs = [db executeQuery:sqlString];
        while([rs next]) {
            HYBaseModel * model = [[[NSClassFromString(self.modelClassString) class] alloc]init];
            
            for(NSString* key in [self.keyTypeDict allKeys]){
                id val = [self dbValueForKey:rs key:key];
                
                if ([model customSetValue:val forProperty:[self propertyForKey:key]]) {
                    continue;
                }
                [model setValue:val forKey:[self propertyForKey:key]];
            }
            
            [allRecordArray addObject:model];
        }
    }];
    
    return [NSArray arrayWithArray:allRecordArray];
}


- (long long)getRecordNumber
{
    
    __block int64_t recordNumber = 0;
    [self.databaseQueue inDatabase:^(HYFMDatabase *db) {
        NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT() FROM %@ ",self.tableName];
        HYFMResultSet * rs = [db executeQuery:sqlString];
        if ([rs next]) {
            recordNumber = [rs intForColumn:@"COUNT()"];
        }
        [rs close];
    }];
    return recordNumber;
}

/**
 *  add record
 */
- (BOOL)addRecord:(HYBaseModel *) recordModel
{
    __block BOOL result = NO;
    [self.databaseQueue inDatabase:^(HYFMDatabase *db) {
        if (recordModel) {
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values(%@)",self.tableName, [self buildAllFieldKeyString], [self buildAllFieldTypeSymbolStringWithRecord:recordModel] ];
            
            result = [db executeUpdate:sql];
        }
        
    }];
    return result;
}



- (BOOL)updateRecord:(HYBaseModel *)recordModel
{
    return [self updateRecord:recordModel WithAditonCondition:nil];
}


- (BOOL)updateRecord:(HYBaseModel *)recordModel WithAditonCondition:(NSString *)condition
{
    __block BOOL rst = NO;
    [self.databaseQueue inDatabase:^(HYFMDatabase *db) {
        if (recordModel) {
            NSString *sql;
            
            if(!condition){
                sql = [NSString stringWithFormat:@"update %@ set %@",self.tableName, [self buildAllFieldAndValueStringWithRecord:recordModel] ];
            }else{
                sql = [NSString stringWithFormat:@"update %@ set %@ where %@",self.tableName, [self buildAllFieldAndValueStringWithRecord:recordModel], condition ];
            }

            
            rst = [db executeUpdate:sql];
        }
        
    }];
    
    return rst;
}


- (BOOL)deleteRecordWithID:(NSString *) recordID;
{
    //    __block BOOL result = NO;
    //    [self.databaseQueue inDatabase:^(FMDatabase *db) {
    //        if (recordID) {
    //            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ",TeleHistory_Table,teleRecordModel.contacterName,teleRecordModel.callDate];
    //            result = [db executeUpdate:sql];
    //        }
    //    }];
    //
    //    return result;
    
    DDLogError(@"You MUST implement it in child class!");
    
    GSAssert(NO);
    
    return NO;
}



- (BOOL)deleteRecordWithAddtionConditon:(NSString *) condition
{
    //contacterName = '%@' AND callDate = '%@'
    
    __block BOOL result = NO;
    [self.databaseQueue inDatabase:^(HYFMDatabase *db) {
        if (condition) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",self.tableName,condition];
            result = [db executeUpdate:sql];
        }
    }];
    
    return result;
}

- (BOOL)deleteAllRecords
{
    __block BOOL result = NO;
    [self.databaseQueue inDatabase:^(HYFMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ ",self.tableName];
        result = [db executeUpdate:sql];
    }];
    return result;
}





#pragma mark - internal functions

-(NSArray*)getPropertyList
{
    NSMutableArray* array = [NSMutableArray array];
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([NSClassFromString(self.modelClassString) class], &outCount);
    
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        
        //        NSString * key2 = [[NSString alloc]initWithCString:property_getAttributes(property)  encoding:NSUTF8StringEncoding];
        //
        //        NSString* type = [self getPropetyType:property];
        //
        //        DDLogInfo(@"property[%d] :%@: type:%@  \n", i, key2,type);
        
        [array safeAddObject:key];
    }
    
    SafeFree(properties);
    
    return array;
}

-(NSString*)getPropetyType:(objc_property_t)property
{
    NSString* ptype;
    
    NSString * pAttr = [[NSString alloc]initWithCString:property_getAttributes(property)  encoding:NSUTF8StringEncoding];
    NSRange range = [pAttr rangeOfString:@","];
    
    NSString* typeString = [pAttr substringWithRange:NSMakeRange(0, range.location)];
    
    
    if([typeString hasPrefix:@"T@"]){
        NSArray* array = [typeString componentsSeparatedByString:@"\""];
        ptype = [array safeObjectAtIndex:1];
    }else{
        return typeString;
    }
        
//        if([typeString isEqualToString:@"Ti"]){
//        return @"NSInteger";
//    }else if([typeString isEqualToString:@"Tc"]){
//        return @"char";
//    }else if([typeString isEqualToString:@"Td"]){
//        return @"double";
//    }else if([typeString isEqualToString:@"Tf"]){
//        return @"float";
//    }else if([typeString isEqualToString:@"Tl"]){
//        return @"long";
//    }else if([typeString isEqualToString:@"Ts"]){
//        return @"short";
//    }else if([typeString isEqualToString:@"TI"]){
//        return @"NSUInteger";
//    }else if([typeString isEqualToString:@"TL"]){
//        return @"unsigned long";
//    }else if([typeString isEqualToString:@"TS"]){
//        return @"unsigned short";
//    }
    
    return ptype;
}


-(NSString*)buildAllFieldKeyString
{
    
    //        NSString *sqlString = [NSString stringWithFormat:@"SELECT userAccount,contacterName,contacterPhoneNumber,isStranger,teleType,teleLocation,callTime,callTimeStampStart,callTimeStampEnd,SUM(contactTimes),callDate,callDuration,callDurationTime,callStatus FROM %@ GROUP BY contacterName, callDate ORDER BY callTimeStampStart DESC;",self.tableName];
    
    NSMutableString* str = [NSMutableString string];
    NSArray* keyArray = [self.keyTypeDict allKeys];
    for(NSInteger i=0; i<[keyArray count]; i++){
        NSString* ele = [keyArray safeObjectAtIndex:i];
        [str appendString:ele];
        if(i+1 != [keyArray count]){
            [str appendString:@","];
        }
    }
    
    return str;
}


-(NSString*)buildAllFieldTypeSymbolStringWithRecord:(HYBaseModel *) recordModel
{
    //            NSString *sql = [NSString stringWithFormat:@"insert into %@ (contacterName,contacterPhoneNumber,callTime,callTimeStampEnd,callDuration,isStranger,teleLocation,teleType,callDate,userAccount,callStatus,callTimeStampStart,callDurationTime,contactTimes) values('%@','%@','%@','%d','%d','%d','%@','%ld','%@','%@','%ld','%d','%@','%d')",TeleHistory_Table,teleRecordModel.contacterName,teleRecordModel.contactPhoneNumber,teleRecordModel.callTime,teleRecordModel.callTimeStampEnd, teleRecordModel.callDuration,teleRecordModel.isStranger,teleRecordModel.teleLocation,(long)teleRecordModel.teleType,teleRecordModel.callDate,teleRecordModel.userAccount,(long)teleRecordModel.callStatus,teleRecordModel.callTimeStampStart,teleRecordModel.callDurationTime,teleRecordModel.contactTimes];
    
    NSMutableString* str = [NSMutableString string];;
    NSArray* keyArray = [self.keyTypeDict allKeys];
    for(NSInteger i=0; i<[keyArray count]; i++){
        NSString* toVal = [self dbStringValueForKey:[keyArray safeObjectAtIndex:i] record:recordModel];
        [str appendString:[NSString stringWithFormat:@"'%@'",toVal]];
        if(i+1 != [keyArray count]){
            [str appendString:@","];
        }
    }
    
    return str; //[NSString stringWithFormat:@"values(%@)",str];
}



-(NSString*)buildAllFieldAndValueStringWithRecord:(HYBaseModel *) recordModel
{
//   NSString *sql = [NSString stringWithFormat:@"update %@ set toUserID = '%@',conversationType = '%u',lastSender = '%@',lastMessageID = '%@',lastMessageStatus = '%u',lastMessageType = '%u',conversationType = '%u',lastTimeStamp = '%ld',lastSender = '%@',lastMessage = '%@',unReadCount = '%ld',msgCount = '%ld',isTop = '%d',isHide = '%d',policy = '%u',draftContent = '%@',draftTimeStamp = '%ld' where conversationUUID = '%@'",CONVERSATION_TABLE,conversation.toUserID,conversation.conversationType,conversation.lastSender,conversation.lastMessageID,conversation.lastMessageStatus,conversation.lastMessageType,conversation.conversationType,(long)conversation.lastTimeStamp,conversation.lastSender,conversation.lastMessage,(long)conversation.unReadCount,(long)conversation.msgCount,conversation.isTop,conversation.isHide,conversation.policy,conversation.draftContent,(long)conversation.draftTimeStamp,conversation.conversationUUID];
    
    NSMutableString* str = [NSMutableString string];;
    NSArray* keyArray = [self.keyTypeDict allKeys];
    for(NSInteger i=0; i<[keyArray count]; i++){
        
        [str appendString:[keyArray safeObjectAtIndex:i]];
        [str appendString:@" = "];
        
        NSString* toVal = [self dbStringValueForKey:[keyArray safeObjectAtIndex:i] record:recordModel];
        [str appendString:[NSString stringWithFormat:@"'%@'",toVal]];
        if(i+1 != [keyArray count]){
            [str appendString:@","];
        }
    }
    
    return str; //[NSString stringWithFormat:@"values(%@)",str];
}


-(NSString*)dbStringValueForKey:(NSString*)key record:(HYBaseModel *) recordModel
{
    NSString* value;
    
    dbType type = [self dbTypeWithKey:key];

    id recordValue = [recordModel valueForKey:key];
    
    switch (type) {
        case dbType_string:
            value = [NSString stringWithFormat:@"%@",recordValue];
            break;
            
        case dbType_int:
            value = [NSString stringWithFormat:@"%d",[(NSNumber*)recordValue intValue] ];
            break;
            
        case dbType_long:
            value = [NSString stringWithFormat:@"%ld",[(NSNumber*)recordValue longValue] ];
            break;
            
        case dbType_longlong:
            value = [NSString stringWithFormat:@"%lld",[(NSNumber*)recordValue longLongValue] ];
            break;
            
        case dbType_bool:
            value = [NSString stringWithFormat:@"%d",[(NSNumber*)recordValue boolValue] ];
            break;
            
        case dbType_float:
            value = [NSString stringWithFormat:@"%f",[(NSNumber*)recordValue floatValue] ];
            break;
            
        case dbType_double:
            value = [NSString stringWithFormat:@"%f",[(NSNumber*)recordValue doubleValue] ];
            break;
            
            
            //TODO: FIX ME
        case dbType_date:
            value = @"%ld";
            break;
            
        case dbType_data:
            value = @"%ld";
            break;
            
        case dbType_obj:
            value = @"%ld";
            break;
            
        default:
            break;
    }
    
    return value;
}

-(id)dbValueForKey:(HYFMResultSet *) rs key:(NSString*)key
{
    id value;


    dbType type = [self dbTypeWithKey:key];
    
    switch (type) {
        case dbType_string:
            value = [rs stringForColumn:key];
            break;
            
        case dbType_int:
            value = [NSNumber numberWithInt:[rs intForColumn:key]];
            break;
            
        case dbType_long:
            value = [NSNumber numberWithLong:[rs longForColumn:key]];
            break;
            
        case dbType_longlong:
            value = [NSNumber numberWithLongLong:[rs longLongIntForColumn:key]];
            break;
            
        case dbType_bool:
            value = [NSNumber numberWithBool:[rs boolForColumn:key]];
            break;
            
        case dbType_float:
            value = [NSNumber numberWithDouble:[rs doubleForColumn:key]];
            break;
            
        case dbType_double:
            value = [NSNumber numberWithDouble:[rs doubleForColumn:key]];
            break;
            
        case dbType_date:
            value = [rs dateForColumn:key];
            break;
            
        case dbType_data:
            value = [rs dataForColumn:key];
            break;
            
        case dbType_obj:
            value = [rs objectForColumnName:key];
            break;
            
        default:
            break;
    }
    
    
    return value;
}


-(NSString*)dbDescriptionForKey:(NSString*)key
{
    NSString* value = @"text";
    
    
    BOOL isPrimaryKey;
    NSInteger orig = [[self.keyTypeDict safeObjectForKey:key] integerValue];
//    orig = (1 << 8) + dbType_string;
    isPrimaryKey = (orig >> 8) & 0xFF;
    
    dbType type = [self dbTypeWithKey:key];

    
    switch (type) {
        case dbType_string:
            value = @"text";
            break;
            
        case dbType_int:
            value = @"integer";
            break;
            
        case dbType_long:
            value = @"integer";
            break;
            
        case dbType_longlong:
            value = @"integer";
            break;
            
        case dbType_bool:
            value = @"bool";
            break;
            
        case dbType_float:
            value = @"";
            break;
            
        case dbType_double:
            value = @"";
            break;
            
        case dbType_date:
            value = @"";
            break;
            
        case dbType_data:
            value = @"";
            break;
            
        case dbType_obj:
            value = @"";
            break;
            
        default:
            break;
    }
    
    if(isPrimaryKey){
        //primary key
        value = [NSString stringWithFormat:@"%@ primary key",value];
    }
    
    return value;
}



-(NSString*)propertyForKey:(NSString*)key
{
    return key;
}

-(dbType)dbTypeWithKey:(NSString*)key
{
    NSInteger orig = [[self.keyTypeDict safeObjectForKey:key] integerValue];
    
    //    orig = (1 << 8) + dbType_string;
    
    dbType type = orig & 0xFF;
    
    return type;
}

-(dbType)dbTypeWithValue:(NSString*)valueIn
{
    dbType type = dbType_string;
    NSArray* array = [valueIn componentsSeparatedByString:@" "];
    NSString* value = [array safeObjectAtIndex:0];
    
//    case dbType_string:
//        value = @"text";
//        break;
//        
//    case dbType_int:
//        value = @"integer";
//        break;
//        
//    case dbType_long:
//        value = @"integer";
//        break;
//        
//    case dbType_longlong:
//        value = @"integer";
//        break;
//        
//    case dbType_bool:
//        value = @"bool";
//        break;
//        
//    case dbType_float:
//        value = @"";
//        break;
//        
//    case dbType_double:
//        value = @"";
//        break;
//        
//    case dbType_date:
//        value = @"";
//        break;
//        
//    case dbType_data:
//        value = @"";
//        break;
//        
//    case dbType_obj:
//        value = @"";
//        break;

    
    if([value isEqualToString:@"text"]){
        type = dbType_string;
    }else if([value isEqualToString:@"integer"] || [value isEqualToString:@"int"]){
        type = dbType_int;
    }else if([value isEqualToString:@"bigint"]){
        type = dbType_longlong;
    }else if([value isEqualToString:@"real"] || [value isEqualToString:@"double"]){
        type = dbType_double;
    }else if([value isEqualToString:@"float"]){
        type = dbType_float;
    }else if([value isEqualToString:@"bool"]){
        type = dbType_bool;
    }else if([value isEqualToString:@"date"]){
        type = dbType_date;
    }else if([value isEqualToString:@""]){
        type = dbType_string;
    }else if([value isEqualToString:@""]){
        type = dbType_string;
    }else if([value isEqualToString:@""]){
        type = dbType_string;
    }
    
    return type;
}

-(BOOL)isValidKeyToModel
{
    BOOL ret = YES;
    
#ifdef DEBUG
    HYBaseModel * model = [[[NSClassFromString(self.modelClassString) class] alloc]init];

    for (NSString* key in self.keyTypeDict) {
        if (![model respondsToSelector:NSSelectorFromString(key)]) {
            DDLogError(@"Your key(%@) is not mapped to the model(%@)!",key, self.modelClassString);
            ret = NO;
            break;
        }
    }
    
    if (!ret) {
        GSAssert(NO);
    }
    
#endif
    
    return ret;
}


@end
