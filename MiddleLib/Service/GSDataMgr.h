//
//  GSDataMgr.h
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDataModel.h"

typedef enum {
    marketType_All = 0,
    marketType_ShangHai,
    marketType_ShenZhenAll,
    marketType_ShenZhenMainAndZhenXiaoBan,
    marketType_ShenZhenChuanYeBan
}MarketType;

@interface GSDataMgr : NSObject
+(GSDataMgr*)shareInstance;


//@property (nonatomic,strong) NSMutableArray* contentArray;
@property (nonatomic,strong) NSMutableArray* sourceFileArray;


@property (assign) int startDate; //start analysis date, such as 20140101
@property (assign) int endDate; //end analysis date, such as 20140101

@property (assign) MarketType marketType;
@property (nonatomic, assign) BOOL isJustWriteNSTK;

-(void)writeDataToDB:(NSString*)docsDir EndDate:(int)dataEndDate;
-(NSArray*)getDayDataFromDB:(NSString*)stkID;
-(NSArray*)getWeekDataFromDB:(NSString*)stkID;
-(NSArray*)getMonthDataFromDB:(NSString*)stkID;
-(NSArray*)getNSTKDayDataFromDB:(NSString*)stkID;

/**
 *  add the record from db last data last day. from network.
 */
-(void)updateDataToDBFromNet;

-(NSArray*)getStkRangeFromQueryDB;



-(NSMutableArray*)findSourcesInDir:(NSString*)docsDir;
-(NSMutableArray*)getStkContentArray:(NSString*)filePath;







@end
