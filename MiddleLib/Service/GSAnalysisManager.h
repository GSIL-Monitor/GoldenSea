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
#import "GSDataInit.h"








@interface GSAnalysisManager : NSObject

+(GSAnalysisManager*)shareManager;


@property (nonatomic,strong) NSMutableArray* resultArray;
@property (assign) int totalCount;


//below is need set--->


//we will analysis the data which simlar as this value
@property (strong) KDataModel* currT0KData;
@property (strong) KDataModel* currTP1KData;
@property (strong) KDataModel* currTP2KData; 


@property (strong) OneDayCondition* tp1dayCond;  //t-1 day
@property (strong) OneDayCondition* tp2dayCond;  //t-2 day
@property (strong) OneDayCondition* t0dayCond;    //t day
@property (strong) OneDayCondition* t1dayCond;  //t+1 day


@property (assign) BOOL isWaibaoriDownCond;

//<----------

-(void)analysisFile:(NSString*)stkUUID inDir:(NSString*)docsDir;


@end
