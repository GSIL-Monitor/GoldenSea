//
//  MonthStatAnalysisMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/11/8.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "STATAnalysisMgr.h"

@implementation STATAnalysisMgr


-(BOOL)isMapCondition:(long)i isQuery:(BOOL)isQuery
{
    return YES;
}
-(void)analysis
{
    NSArray* cxtArray = [self getCxtArray:self.period];
    if(! [self isValidDataPassedIn] || [cxtArray count]< 3 ) // || [cxtArray count]<20)
    {
        return;
    }
    
    long statDays = 0;
    for(long i=1; i<[cxtArray count]-statDays; i++){
        CGFloat buyValue = 0.f;
        CGFloat sellValue = 0.f;
        
        KDataModel* kTP4Data  = [cxtArray safeObjectAtIndex:(i-4)];
        KDataModel* kTP3Data  = [cxtArray safeObjectAtIndex:(i-3)];
        KDataModel* kTP2Data  = [cxtArray safeObjectAtIndex:(i-2)];
        KDataModel* kTP1Data  = [cxtArray safeObjectAtIndex:(i-1)];
        KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
        //        KDataModel* kT1Data = [cxtArray safeObjectAtIndex:(i+1)];
        
        
        kT0Data.tradeDbg.TBuyData = kT0Data;
        [self dispatchResult2Array:kT0Data buyValue:kT0Data.open sellValue:kT0Data.close];


    }
    
    
    [[GSObjMgr shareInstance].log SimpleLogOutResult:NO];
    
}

@end
