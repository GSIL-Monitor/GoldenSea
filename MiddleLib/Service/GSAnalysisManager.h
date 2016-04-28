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

typedef enum {
    Period_3m = 0, //three month
    Period_1y,       //1 year
    Period_2y       //2 year
}Period;


typedef enum {
    ConditionKind_Open = 0,
    ConditionKind_Close,
    ConditionKind_High,
    ConditionKind_Low
}ConditionKind;








@interface GSAnalysisManager : NSObject

+(GSAnalysisManager*)shareManager;

//we will analysis the data which simlar as this value
@property (strong) KDataModel* currT0KData;
@property (strong) KDataModel* currTP1KData;
@property (strong) KDataModel* currTP2KData; 


@property (assign) Period period;
@property (strong) OneDayCondition* tp1dayCond;  //t-1 day
@property (strong) OneDayCondition* tp2dayCond;  //t-2 day
@property (strong) OneDayCondition* t0dayCond;    //t day
@property (strong) OneDayCondition* t1dayCond;  //t+1 day





-(void)parseFile:(NSString*)stkUUID inDir:(NSString*)docsDir;


@end
