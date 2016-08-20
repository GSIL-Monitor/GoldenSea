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
@interface RaisingLimitParam : NSObject



@property (assign) long durationAfterBuy; //the duaration(t+n day) after the buy day.
@property (assign) CGFloat buyPercent; //such as 0.95
// daysAfterLastLimit = this rasieLimit time -  the last limit time. such as 30. if=0 means no this conditon 
@property (nonatomic, assign) long daysAfterLastLimit;

-(BOOL)isMapRasingLimitAvgConditon:(KDataModel*)kTP1Data;
-(BOOL)isMapRasingLimitAvgConditonMa30:(KDataModel*)kTP1Data;


-(BOOL)isNoLimitInLastDaysBeforeIndex:(long)currIndex contentArray:(NSArray*)contentArray;

@end
