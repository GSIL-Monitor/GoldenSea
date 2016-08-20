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





@interface GSBaseAnalysisMgr : NSObject

+(GSBaseAnalysisMgr*)shareInstance;

@property (nonatomic,strong) NSArray* contentArray;
@property (nonatomic,strong) NSString* stkID;

//reslut realted
@property (nonatomic,strong) NSMutableArray* resultArray;
@property (assign) int totalCount;
@property (nonatomic, assign) CGFloat totalS2BDVValue;

@property (nonatomic,strong) NSMutableArray* allResultArray;
@property (nonatomic,strong) NSMutableDictionary* allResultDict;
@property (assign) int allTotalCount;
@property (nonatomic, assign) CGFloat allTotalS2BDVValue;



//below is need set--->
//such as SZ300112 etc.
@property (nonatomic, strong) NSArray* stkRangeArray; //if nil,means all stk.
@property (nonatomic, strong) RaisingLimitParam* param;

@property (assign) CGFloat destDVValue;
@property (assign) CGFloat stopDVValue;


//we will analysis the data which simlar as this value
@property (strong) KDataModel* currT0KData;
@property (strong) KDataModel* currTP1KData;
@property (strong) KDataModel* currTP2KData; 


@property (strong) OneDayCondition* tp1dayCond;  //t-1 day
@property (strong) OneDayCondition* tp2dayCond;  //t-2 day
@property (strong) OneDayCondition* t0dayCond;    //t day
@property (strong) OneDayCondition* t1dayCond;  //t+1 day



//<----------


-(void)analysisAllInDir:(NSString*)docsDir;


//query action
-(void)queryAllInDir:(NSString*)docsDir;
-(void)buildQueryAllDBInDir:(NSString*)docsDir;





//protected class used function
-(CGFloat)getSellValue:(CGFloat)buyValue bIndexInArray:(NSUInteger)bIndexInArray kT0data:(KDataModel*)kT0Data;


@end
