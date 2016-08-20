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


@property (nonatomic,strong) NSMutableArray* contentArray;
@property (nonatomic,strong) NSMutableArray* sourceFileArray;


@property (assign) int startDate; //start analysis date, such as 20140101
@property (assign) int endDate; //end analysis date, such as 20140101

@property (assign) MarketType marketType;

-(void)writeDataToDB:(NSString*)docsDir;
-(void)writeDataToDB:(NSString*)docsDir FromDate:(int)startDate;
-(NSArray*)getDataFromDB:(NSString*)stkID;


-(NSArray*)getStkRangeFromQueryDB;



-(NSMutableArray*)findSourcesInDir:(NSString*)docsDir;
-(NSMutableArray*)getStkContentArray:(NSString*)filePath;


-(CGFloat)getDVValueWithBaseValue:(CGFloat)baseValue destValue:(CGFloat)destValue;

-(DVValue*)getDVValue:(NSArray*)tmpContentArray baseIndex:(long)baseIndex destIndex:(long)destIndex;
-(DVValue*)getAvgDVValue:(NSUInteger)days array:(NSArray*)tmpContentArray index:(long)index;
-(CGFloat)getMAValue:(NSUInteger)days array:(NSArray*)tmpContentArray t0Index:(long)t0Index;


-(BOOL)isSimlarValue:(CGFloat)destValue baseValue:(CGFloat)baseValue Offset:(CGFloat)offset;

@end
