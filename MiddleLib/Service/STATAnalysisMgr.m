//
//  MonthStatAnalysisMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/11/8.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "STATAnalysisMgr.h"

@implementation STKResult

-(id)init
{
    if(self = [super init]){
        self.avgDV = 0.f;
        self.eleArray = [NSMutableArray array];
    }
    
    return self;
}

@end


@implementation STATAnalysisMgr

-(id)init
{
    if(self = [super init]){
        self.statResultArray = [NSMutableArray array];
    }
    
    return self;
}

-(BOOL)isMapCondition:(long)i isQuery:(BOOL)isQuery
{
    return YES;
}

//query January


-(void)analysis
{
    NSArray* cxtArray = [self getCxtArray:self.period];
    if(! [self isValidDataPassedIn] || [cxtArray count]< 3 ) // || [cxtArray count]<20)
    {
        return;
    }
    
    long statDays = 0;
    STKResult* stkResult = [[STKResult alloc]init];
    CGFloat totolDV = 0.f;
    for(long i=1; i<[cxtArray count]; i++){
        
        KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];

        [[GSDataMgr shareInstance]setCanlendarInfo:kT0Data];
        if(kT0Data.unitDbg.month != 1){
            continue;
        }
        
        KDataModel* kTP1Data  = [cxtArray objectAtIndex:(i-1)];

        kT0Data.dvDbg.dvT0.dvClose = kT0Data.close/kTP1Data.close;
        totolDV += kT0Data.dvDbg.dvT0.dvClose;
        [stkResult.eleArray addObject:kT0Data];
    }
    
    if([stkResult.eleArray count] > 2){
        stkResult.stkID = self.stkID;
        stkResult.avgDV = totolDV/[stkResult.eleArray count];
        [self.statResultArray addObject:stkResult];
    }
    
}

@end
