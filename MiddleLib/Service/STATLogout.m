//
//  STATLogout.m
//  GSGoldenSea
//
//  Created by frank weng on 16/12/21.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "STATLogout.h"
#import "STATAnalysisMgr.h"

@implementation STATLogout


-(NSArray*)reOrderResultArray:(NSArray*)array
{
    NSArray *resultArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        STKResult* par1 = obj1;
        STKResult* par2 = obj2;
        
        NSNumber *number1 = [NSNumber numberWithFloat: par1.avgDV];
        NSNumber *number2 = [NSNumber numberWithFloat: par2.avgDV];
        
        
        NSComparisonResult result = [number1 compare:number2];
        
        //        return result == NSOrderedDescending; // 升序
        return result == NSOrderedAscending;  // 降序
    }];
    
    
    return resultArray;
}


-(CGFloat)getAvg16DV:(NSMutableArray*)resultArray
{
    CGFloat totolDV=0.f, totalAvgDV=0.f;
    long validCount=0;
    for(long i=0; i<[resultArray count]; i++){
        STKResult* stkResult = [resultArray safeObjectAtIndex:i];
        totolDV += stkResult.the2016DV;
        if(stkResult.the2016DV >0.1f){
            validCount++;
        }
    }
    totalAvgDV = totolDV/validCount;
    
    return totalAvgDV;
}

-(void)analysisAndLogtoFile;
{
    
    [[HYLog shareInstance] enableLog];
    
    STATAnalysisMgr* mgr = (STATAnalysisMgr*)[GSObjMgr shareInstance].mgr;
    NSArray* resultArray = mgr.statResultArray;
    
    resultArray = [self reOrderResultArray: resultArray];

    
    //calulate percent firstly
    
    CGFloat totalAvgDV = [self getAvg16DV:mgr.statResultArray];
    CGFloat dbgAvgDV = [self getAvg16DV:mgr.dbgResultArray];
    CGFloat badAvgDV = [self getAvg16DV:mgr.badResultArray];
    
    SMLog(@"totalAvgDV:%.3f, dbgAvgDV:%.3f, badAvgDV:%.3f",totalAvgDV,dbgAvgDV,badAvgDV);
    return;
    
    for(long i=0; i<[resultArray count]; i++){
        STKResult* stkResult = [resultArray safeObjectAtIndex:i];
        SMLog(@"No%d %@: avgDV:%.2f, avgHighDV:%.2f, LastDV:%.2f, 16dv:%.2f, 16Highdv:%.2f, 16LowDV:%.2f",i,stkResult.stkID,stkResult.avgDV, stkResult.avgHighDV,stkResult.LastDV,stkResult.the2016DV,stkResult.the2016HighDV,stkResult.the2016LowDV);

        for (KDataModel* kData in stkResult.eleArray) {
            SMLog(@"time:%ld, dvT0:%.2f, dvHigh:%.2f",kData.time,kData.dvDbg.dvT0.dvClose,kData.dvDbg.dvT0.dvHigh);
        }
    }
    
    
    [[HYLog shareInstance] disableLog];
    
    SMLog(@"<--end of analysisAndLogtoFile");
}


@end
