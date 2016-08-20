//
//  RaisingLimitParam.m
//  GSGoldenSea
//
//  Created by frank weng on 16-8-17.
//  Copyright (c) 2016年 frank weng. All rights reserved.
//

#import "RaisingLimitParam.h"

@implementation RaisingLimitParam

SINGLETON_GENERATOR(RaisingLimitParam, shareInstance);


-(id)init
{
    if(self = [super init]){
        self.durationAfterBuy = kInvalidData_Base+1;
        self.buyPercent = kInvalidData_Base+1;
    }
    
    return self;
}

-(BOOL)isMapRasingLimitAvgConditon:(KDataModel*)kTP1Data
{
    CGFloat dvMa5AndClose = [[GSDataInit shareInstance]getDVValueWithBaseValue:kTP1Data.ma5 destValue:kTP1Data.close];
    CGFloat dvMa10AndClose = [[GSDataInit shareInstance]getDVValueWithBaseValue:kTP1Data.ma10 destValue:kTP1Data.close];
    if(dvMa5AndClose > 6.f
       || dvMa10AndClose < -8.f
       ){
        return NO;
    }
    
    return YES;
}

-(BOOL)isMapRasingLimitAvgConditonMa30:(KDataModel*)kTP1Data
{
    CGFloat dvMa30AndClose = [[GSDataInit shareInstance]getDVValueWithBaseValue:kTP1Data.ma30 destValue:kTP1Data.close];
//    CGFloat dvMa10AndClose = [[GSDataInit shareInstance]getDVValueWithBaseValue:kTP1Data.ma10 destValue:kTP1Data.close];
    if(dvMa30AndClose > 10.f
//       || dvMa10AndClose < -8.f
       ){
        return NO;
    }
    
    return YES;
}


-(BOOL)isNoLimitInLastDaysBeforeIndex:(long)currIndex contentArray:(NSArray*)contentArray;
{
    if(self.daysAfterLastLimit == 0){
        return YES;
    }
    
//    long currIndex = kT0Data.tIndex;
    long lastIndex = currIndex>=self.daysAfterLastLimit ? (currIndex-self.daysAfterLastLimit):0;
    
    for(long i=lastIndex; i<currIndex; i++){
        KDataModel* tmp = [contentArray objectAtIndex:i];
        if(tmp.isLimitUp){
            return NO;
        }
    }
    
    return YES;
}


@end
