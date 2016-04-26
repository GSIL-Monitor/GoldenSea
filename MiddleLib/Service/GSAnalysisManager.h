//
//  GSFileManager.h
//  GSGoldenSea
//
//  Created by frank weng on 16/4/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Period_3m = 0, //three month
    Period_1y,       //1 year
    Period_2y       //2 year
}Period;


typedef struct {
    CGFloat close_min; //the min value, close vs open, (percent)
    CGFloat close_max;
}OneDayCondition;







@interface GSAnalysisManager : NSObject

+(GSAnalysisManager*)shareManager;

@property (assign) Period period;
@property (assign) OneDayCondition tp1dayCond;  //t-1 day
@property (assign) OneDayCondition tp2dayCond;  //t-2 day
@property (assign) OneDayCondition t0dayCond;    //t day
@property (assign) OneDayCondition t1dayCond;  //t+1 day



// this can be set from -20 to 20, if the value greate than 100, we skip the limit
@property (assign) int DVUnitOfT0DayOpenAndTP1DayClose; //the differ unit num between the second open and the first close. 0.5 is one unit.
@property (assign) CGFloat  DVUnitValue; //one uint value, default is 0.5,



-(void)parseFile:(NSString*)stkUUID inDir:(NSString*)docsDir;


@end
