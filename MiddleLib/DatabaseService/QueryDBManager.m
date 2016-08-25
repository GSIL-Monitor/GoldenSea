//
//  QueryDBManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/19.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "QueryDBManager.h"
#import "HYDatabaseHelper.h"
#import "QueryResDBService.h"

@interface QueryDBManager ()
@property (nonatomic, strong) HYDatabaseHelper        *DBHelper;
@end

@implementation QueryDBManager

SINGLETON_GENERATOR(QueryDBManager, defaultManager)

-(id)init
{
    if(self = [super init]){
    }
    
    return self;
}

- (void)setupDB:(NSString*)dbPath isReset:(BOOL)isReset;
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyyMMdd HH.mm.ss"];
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    NSString * strNowDateTime = [df stringFromDate:currentDate];
    NSString *strNowDate= [strNowDateTime substringToIndex:8];
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* querydbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSQuery%@.db",[paths stringByDeletingLastPathComponent],strNowDate];
    
    self.DBHelper = [[HYDatabaseHelper alloc]init];
    [self.DBHelper setupDB:querydbdir isReset:isReset];
    
    
    self.qREsDBService = [[QueryResDBService alloc]init];
    [self.qREsDBService setup:self.DBHelper];
    if([self.qREsDBService createTableWithName:@"tQueryBasicInfo"]){
//        DDLogInfo(@"tQueryBasicInfo table create success!");
    }else{
        DDLogInfo(@"tQueryBasicInfo table create failed!");
    }
    
    
}

- (BOOL)closeDB
{
    BOOL rst = [self.DBHelper closeDB];
    return rst;
}

@end
