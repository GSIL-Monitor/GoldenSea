//
//  RaisingLimitParam.h
//  GSGoldenSea
//
//  Created by frank weng on 16-8-17.
//  Copyright (c) 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSBaseParam.h"

//tbd.
@interface RaisingLimitParam : GSBaseParam



@property (assign) long durationAfterBuy; //the duaration(t+n day) after the buy day.
@property (assign) CGFloat buyPercent; //such as 0.95,相对于tp1data的ma5的百分比
// daysAfterLastLimit = this rasieLimit time -  the last limit time. such as 30. if=0 means no this conditon 
@property (nonatomic, assign) long daysAfterLastLimit;



//检测在T日涨停之前，是否至少有daysAfterLastLimit日没有发生过涨停
-(BOOL)isNoLimitInLastDaysBeforeIndex:(long)currIndex contentArray:(NSArray*)contentArray;

@end
