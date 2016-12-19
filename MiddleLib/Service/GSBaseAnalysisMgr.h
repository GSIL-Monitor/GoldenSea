//
//  GSFileManager.h
//  GSGoldenSea
//
//  Created by frank weng on 16/4/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDataModel.h"
#import "OneDayCondition.h"
#import "GSDataMgr.h"


#import "GSBaseParam.h"
#import "GSBaseResult.h"


typedef enum {
    Period_day = 0,
    Period_week,
    Period_month
}Period;



@interface GSBaseAnalysisMgr : NSObject


//@property (nonatomic,strong) NSArray* contentArray;
@property (nonatomic,strong) NSArray* dayCxtArray;
@property (nonatomic,strong) NSArray* weekCxtArray;
@property (nonatomic,strong) NSArray* monthCxtArray;
@property (nonatomic,strong) NSArray* NSTKdayCxtArray;
@property (nonatomic,strong) NSString* stkID;

@property (nonatomic, assign) Period period;


@property (nonatomic, strong) NSMutableArray* querySTKArray;
@property (nonatomic, strong) NSMutableArray* queryResArray;


//for query
@property (nonatomic, assign) BOOL isWriteToQueryDB;


//such as SZ300112 etc.
@property (nonatomic, strong) NSArray* stkRangeArray; //if nil,means all stk. it's passed by client
@property (nonatomic, strong) NSMutableArray* realStkRangeArray; //if nil,wiil add all stk.
@property (nonatomic, strong) GSBaseParam* param;
@property (nonatomic, strong) GSBaseResult* reslut;

//we will analysis the data which simlar as this value
@property (strong) KDataModel* currT0KData;
@property (strong) KDataModel* currTP1KData;
@property (strong) KDataModel* currTP2KData; 


@property (strong) OneDayCondition* tp1dayCond;  //t-1 day
@property (strong) OneDayCondition* tp2dayCond;  //t-2 day
@property (strong) OneDayCondition* t0dayCond;    //t day
@property (strong) OneDayCondition* t1dayCond;  //t+1 day


//analysis all.
-(void)analysisAllInDir:(NSString*)docsDir;

//anlaysis the query stk
-(void)analysisQuerySTKArray:(NSString*)docsDir;


//query action
-(void)queryAllWithDB:(NSString*)docsDir;
-(void)queryAllWithFile:(NSString*)docsDir;



//protected class used function
-(CGFloat)getSellValue:(CGFloat)buyValue kT0data:(KDataModel*)kT0Data  cxtArray:(NSArray*)cxtArray start:(long)startIndex stop:(long)stopIndex;
-(void)queryAndLogtoDB;
-(NSArray*)getCxtArray:(long)period;

@end
